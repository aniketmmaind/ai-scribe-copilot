import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phone_state/phone_state.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class RecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<PhoneState>? _callSub;

  final int chunkMs;
  final Uuid uuid = Uuid();
  late Directory baseDir;

  StreamController<String>? _controller;
  bool _controllerClosed = false;
  bool _sinkOpen = false;

  Timer? _timer;
  IOSink? _currentSink;
  String? _currentPath;
  bool _isRecording = false;
  bool _isPaused = false;

  Function()? onCallStarted; // callback pause
  Function()? onCallEnded; // callback resume
  Function(Uint8List pcm)? onPcmFrame;

  // for UI waveform
  final StreamController<double> _dbController = StreamController.broadcast();

  Stream<double> get decibelStream => _dbController.stream;

  RecorderService._(this.chunkMs);

  void setCallHandlers({Function()? onCallStarted, Function()? onCallEnded}) {
    this.onCallStarted = onCallStarted;
    this.onCallEnded = onCallEnded;
  }

  static Future<RecorderService> create({
    required String sessionId,
    int chunkMs = 2000,
  }) async {
    final instance = RecorderService._(chunkMs);

    final root = await getApplicationDocumentsDirectory();
    instance.baseDir = Directory('${root.path}/recordings/$sessionId');

    if (!instance.baseDir.existsSync()) {
      instance.baseDir.createSync(recursive: true);
    }

    return instance;
  }

  String _newChunkPath() {
    final id = uuid.v4();
    return "${baseDir.path}/chunk_$id.wav";
  }

  /// Start PCM recording that rotates a WAV file every chunkMs.
  Stream<String> startRecordingStream() async* {
    if (_isRecording) return;

    _controller = StreamController<String>();

    // Start PCM stream (16-bit)
    final stream = await _recorder.startStream(
      //it also worked for IOS
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
        autoGain: false,
        echoCancel: false,
        noiseSuppress: false,
        androidConfig: AndroidRecordConfig(
          audioSource: AndroidAudioSource.voiceRecognition,
        ),
      ),
    );

    _isRecording = true;
    _startCallListener();

    // Create first chunk file
    _currentPath = _newChunkPath();
    _currentSink = File(_currentPath!).openWrite();
    _sinkOpen = true;

    // Rotate chunks every X ms
    _timer = Timer.periodic(Duration(milliseconds: chunkMs), (_) async {
      if (!_isRecording || _isPaused) return;
      if (_currentSink == null || _currentPath == null) return;

      await _currentSink?.close();
      _safeAdd(_currentPath!);
      _sinkOpen = false;

      _currentPath = _newChunkPath();
      _currentSink = File(_currentPath!).openWrite();
      _sinkOpen = true;
    });

    // Write PCM frames continuously
    stream.listen(
      (Uint8List data) {
        // print(
        //   "PCM rms=${_calculateDB(data).toStringAsFixed(2)} dB, ",

        // "route=$currentRoute",
        // );
        if (!_isRecording || _isPaused) return;

        // write to file
        if (_sinkOpen && _currentSink != null) {
          try {
            _currentSink!.add(data);
          } catch (_) {}
        }

        // send to Deepgram
        if (onPcmFrame != null) {
          onPcmFrame!(data);
        }

        // waveform
        final db = _calculateDB(data);
        _dbController.add(db);
      },
      onDone: () async {
        await _currentSink?.close();
        if (_currentPath != null) {
          _safeAdd(_currentPath!);
        }
        await _closeController();
        _sinkOpen = false;
      },
      onError: (e) {
        debugPrint("STREAM ERROR: $e");
      },
    );

    yield* _controller!.stream;
  }

  Future<void> pause() async {
    if (!_isRecording || _isPaused) return;

    _isPaused = true;

    // Stop rotating chunks while paused
    _timer?.cancel();
    _timer = null;
    await _currentSink?.close();
    _sinkOpen = false;
  }

  Future<void> resume() async {
    if (!_isRecording || !_isPaused) return;

    _isPaused = false;

    // Resume chunk rotation
    _timer = Timer.periodic(Duration(milliseconds: chunkMs), (_) async {
      if (!_isRecording || _isPaused) return;

      // Close previous chunk and rotate
      await _currentSink?.close();
      _safeAdd(_currentPath!);

      _currentPath = _newChunkPath();
      _currentSink = File(_currentPath!).openWrite();
      _sinkOpen = true;
    });
  }

  Future<void> _startCallListener() async {
    if (kIsWeb || Platform.isIOS) return;
    _callSub = PhoneState.stream.listen((event) async {
      if (event.status == PhoneStateStatus.CALL_INCOMING ||
          event.status == PhoneStateStatus.CALL_STARTED) {
        onCallStarted?.call();
      }

      if (event.status == PhoneStateStatus.CALL_ENDED) {
        onCallEnded?.call();
      }
    });
  }

  Future<void> stop() async {
    if (!_isRecording) return;

    _callSub?.cancel();
    _callSub = null;

    _isRecording = false;
    _timer?.cancel();
    _timer = null;

    await _recorder.stop();

    await _currentSink?.close();
    _sinkOpen = false;
    _currentSink = null;

    if (_currentPath != null) {
      _safeAdd(_currentPath!);
    }

    await _closeController();
  }

  double _calculateDB(Uint8List pcm) {
    if (pcm.isEmpty) return 0;

    final bytes = pcm.buffer.asByteData();
    double sum = 0;
    int count = 0;

    for (int i = 0; i < pcm.length; i += 2) {
      final sample = bytes.getInt16(i, Endian.little).toDouble();
      sum += sample * sample;
      count++;
    }

    if (count == 0) return 0;

    double rms = sqrt(sum / count);

    if (rms < 1) rms = 1;
    // print("1rms: $rms");

    final db = 20 * log(rms / 32768);

    return db.clamp(-60, 0);
  }

  void _safeAdd(String? path) {
    if (path == null) return;
    if (_controller == null) return;
    if (_controllerClosed) return;

    try {
      _controller!.add(path);
    } catch (_) {}
  }

  Future<void> _closeController() async {
    if (_controller == null) return;
    if (_controllerClosed) return;

    _controllerClosed = true;

    try {
      await _controller!.close();
    } catch (_) {}

    _controller = null;
  }

  void dispose() {
    _recorder.dispose();
  }
}
