// // lib/services/recorder_service.dart
// import 'dart:async';
// import 'dart:io';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:uuid/uuid.dart';
// import 'package:audio_session/audio_session.dart';

// typedef LevelCallback = void Function(double db);

// class RecorderService {
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   bool _inited = false;
//   double gain = 1.0; // simple multiplier for demo
//   StreamSubscription? _dbSub;

//   // chunk settings
//   final int chunkMs; // chunk duration in milliseconds
//   final Directory baseDir;
//   final Uuid uuid = Uuid();

//   RecorderService._internal({required this.baseDir, this.chunkMs = 5000});

//   static Future<RecorderService> create({int chunkMs = 5000}) async {
//     final dir = await getTemporaryDirectory();
//     final s = RecorderService._internal(baseDir: dir, chunkMs: chunkMs);
//     await s._init();
//     return s;
//   }

//   Future<void> _init() async {
//     if (_inited) return;
//     final session = await AudioSession.instance;
//     await session.configure(AudioSessionConfiguration.speech());
//     await _recorder.openRecorder();
//     _inited = true;
//   }

//   /// Start recording to a new file and periodically rotate files every chunkMs
//   ///
//   /// onChunkReady -> called when each chunk file is closed and path returned
//   Stream<String> startRecordingStream() async* {
//     if (!_inited) await _init();

//     String currentPath = _makeChunkPath();
//     await _recorder.startRecorder(
//       // toFile: currentPath,
//       // codec: Codec.pcm16WAV,
//       // sampleRate: 16000,
//       // bitRate: 128000,
//       // numChannels: 1,
//       toFile: currentPath,
//       codec: Codec.pcm16WAV,
//       sampleRate: 16000,
//       numChannels: 1,
//       audioSource: AudioSource.microphone,
//     );

//     // audio level stream
//     _dbSub = _recorder.onProgress?.listen((e) {
//       // e.decibels can be null
//       // We do nothing here; UI can use getRecordStream or a callback
//     });
//     await Future.delayed(const Duration(milliseconds: 300)); // IMPORTANT
//     final chunkDuration = Duration(milliseconds: chunkMs);
//     var running = true;
//     while (running && _recorder.isRecording) {
//       await Future.delayed(chunkDuration);
//       // rotate file
//       await _recorder.stopRecorder();
//       yield currentPath;

//       // start a new chunk
//       currentPath = _makeChunkPath();
//       PermissionStatus status = await Permission.microphone.request();
//       if (status != PermissionStatus.granted)
//         throw RecordingPermissionException("Microphone permission not granted");
//       await _recorder.startRecorder(
//         toFile: currentPath,
//         codec: Codec.pcm16WAV,
//         sampleRate: 16000,
//         bitRate: 128000,
//         numChannels: 1,
//         audioSource: AudioSource.microphone,
//       );
//       await Future.delayed(const Duration(milliseconds: 300)); // IMPORTANT
//     }
//     // final stop
//     if (_recorder.isRecording) {
//       await _recorder.stopRecorder();
//       yield currentPath;
//     }
//   }

//   Future<void> stop() async {
//     if (!_inited) return;
//     if (_dbSub != null) {
//       await _dbSub!.cancel();
//       _dbSub = null;
//     }
//     if (_recorder.isRecording) await _recorder.stopRecorder();
//   }

//   bool get isRecording => _recorder.isRecording ?? false;

//   String _makeChunkPath() {
//     final id = uuid.v4();
//     final name = 'chunk_${id}.wav';
//     return '${baseDir.path}/$name';
//   }

//   Future<double?> getLevel() async {
//     // using onProgress from recorder is preferable
//     return null;
//   }

//   Future<void> dispose() async {
//     await stop();
//     await _recorder.closeRecorder();
//   }
// }

// lib/services/recorder_service.dart
// import 'dart:async';
// import 'dart:io';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:audio_session/audio_session.dart';
// import 'package:uuid/uuid.dart';

// class RecorderService {
//   final FlutterSoundRecorder _rec = FlutterSoundRecorder();
//   bool _inited = false;
//   bool _shouldRun = false;
//   StreamController<String>? _controller;

//   final int chunkMs;
//   final Uuid _uuid = Uuid();
//   late Directory tempDir;

//   RecorderService._(this.chunkMs);

//   static Future<RecorderService> create({int chunkMs = 3000}) async {
//     final r = RecorderService._(chunkMs);
//     await r._init();
//     return r;
//   }

//   Future<void> _init() async {
//     if (_inited) return;

//     tempDir = await getTemporaryDirectory();
//     await Permission.microphone.request();

//     final session = await AudioSession.instance;
//     await session.configure(
//       AudioSessionConfiguration(
//         avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
//         avAudioSessionCategoryOptions:
//             AVAudioSessionCategoryOptions.allowBluetooth |
//             AVAudioSessionCategoryOptions.defaultToSpeaker,
//         androidAudioAttributes: const AndroidAudioAttributes(
//           contentType: AndroidAudioContentType.speech,
//           usage: AndroidAudioUsage.voiceCommunication,
//         ),
//         androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
//         androidWillPauseWhenDucked: false,
//       ),
//     );

//     await _rec.openRecorder();

//     _inited = true;
//   }

//   // Generate new chunk path
//   String _newChunkPath() {
//     final id = _uuid.v4();
//     return "${tempDir.path}/chunk_$id.wav";
//   }

//   /// START RECORDING STREAM
//   Stream<String> startRecordingStream() {
//     if (!_inited) throw Exception("Recorder not initialized");

//     _controller = StreamController<String>();
//     _shouldRun = true;

//     _runRecorderLoop();

//     return _controller!.stream;
//   }

//   /// Internal loop for rotation
//   Future<void> _runRecorderLoop() async {
//     while (_shouldRun) {
//       final String path = _newChunkPath();

//       // Start recorder properly
//       await _rec.startRecorder(
//         toFile: path,
//         codec: Codec.pcm16WAV,
//         sampleRate: 16000,
//         numChannels: 1,
//         audioSource: AudioSource.microphone,
//       );

//       // IMPORTANT: give time for encoder to initialize
//       await Future.delayed(const Duration(milliseconds: 350));

//       // Chunk duration
//       await Future.delayed(Duration(milliseconds: chunkMs));

//       if (!_shouldRun) break;

//       // Stop and finalize chunk
//       await _rec.stopRecorder();

//       int size = await File(path).length();
//       print("CHUNK READY → size=$size bytes :: $path");

//       if (size > 1500) {
//         _controller?.add(path);
//       } else {
//         print("❗ Dropped empty chunk");
//       }
//     }

//     // Final cleanup
//     if (_rec.isRecording) {
//       String lastPath = _newChunkPath();
//       await _rec.stopRecorder();
//       int size = await File(lastPath).length();
//       if (size > 1500) _controller?.add(lastPath);
//     }

//     await _controller?.close();
//   }

//   /// STOP RECORDING
//   Future<void> stop() async {
//     _shouldRun = false;

//     if (_rec.isRecording) {
//       await _rec.stopRecorder();
//     }
//   }

//   bool get isRecording => _rec.isRecording;

//   Future<void> dispose() async {
//     await stop();
//     await _rec.closeRecorder();
//   }
// }

/////////-----------------------------------///////////////////////

// lib/services/recorder_service.dart
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
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

  static Future<RecorderService> create({int chunkMs = 2000}) async {
    final instance = RecorderService._(chunkMs);
    instance.baseDir = await getTemporaryDirectory();
    return instance;
  }

  // Future<bool> _ensurePermission() async {
  //   var mic = await Permission.microphone.request();
  //   return mic.isGranted;
  // }

  String _newChunkPath() {
    final id = uuid.v4();
    return "${baseDir.path}/chunk_${id}.wav";
  }

  /// Start PCM recording that rotates a WAV file every chunkMs.
  Stream<String> startRecordingStream() async* {
    if (_isRecording) return;

    // if (!await _ensurePermission()) {
    //   throw Exception("Microphone permission not granted");
    // }

    _controller = StreamController<String>();

    // Start PCM stream (16-bit)
    final stream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
        autoGain: false,
        echoCancel: false,
        noiseSuppress: false,
        androidConfig: AndroidRecordConfig(
          audioSource: AndroidAudioSource.voiceCommunication,
        ),
      ),
    );

    _isRecording = true;
    _startCallListener();

    // Create first chunk file
    _currentPath = _newChunkPath();
    _currentSink = File(_currentPath!).openWrite();

    // Rotate chunks every X ms
    _timer = Timer.periodic(Duration(milliseconds: chunkMs), (_) async {
      if (!_isRecording || _isPaused) return;
      if (_currentSink == null || _currentPath == null) return;

      await _currentSink?.close();
      _safeAdd(_currentPath!);

      _currentPath = _newChunkPath();
      _currentSink = File(_currentPath!).openWrite();
    });

    // Write PCM frames continuously
    stream.listen(
      (Uint8List data) {
        final silent = data.every((b) => b == 0);
        // print(
        //   "PCM rms=${_calculateDB(data).toStringAsFixed(2)} dB, ",

        // "route=$currentRoute",
        // );
        if (!_isPaused) {
          // Apply gain to PCM16 data
          _currentSink?.add(data);
          print("onPcmFrame: ${onPcmFrame}");
          // Send PCM to Deepgram
          if (onPcmFrame != null) onPcmFrame!(data);
          // calculate decibel from PCM
          final db = _calculateDB(data);
          // convert -60..0 dB → 0..1
          final normalized = ((db + 60) / 60).clamp(0.0, 1.0);
          // print("normalized: $normalized");
          _dbController.add(db);
        }
      },
      onDone: () async {
        await _currentSink?.close();
        if (_currentPath != null) {
          _safeAdd(_currentPath!);
        }
        await _closeController();
      },
      onError: (e) {
        print("STREAM ERROR: $e");
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
    });
  }

  Future<void> _startCallListener() async {
    // final status = await Permission.phone.request();
    // print("status: $status");
    // if (!status.isGranted) {
    //   print("Phone state permission Granted");
    //   return;
    // }
    _callSub = PhoneState.stream.listen((event) async {
      print("event: ${event.status}");
      // if (event == null) return;

      if (event.status == PhoneStateStatus.CALL_INCOMING ||
          event.status == PhoneStateStatus.CALL_STARTED) {
        print("Call detected");
        onCallStarted?.call();
      }

      if (event.status == PhoneStateStatus.CALL_ENDED) {
        onCallEnded?.call();

        // await resume();
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

// lib/services/recorder_service.dart
// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:math' as math;

// import 'package:path_provider/path_provider.dart';
// import 'package:phone_state/phone_state.dart';
// import 'package:record/record.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:uuid/uuid.dart';

// class RecorderService {
//   final AudioRecorder _recorder = AudioRecorder();
//   StreamSubscription<PhoneState>? _callSub;

//   final int chunkMs;
//   final Uuid uuid = Uuid();
//   late Directory baseDir;

//   StreamController<String>? _controller;
//   double _gain = 1.0; // Default 1.0 (no change)

//   Timer? _timer;
//   IOSink? _currentSink;
//   String? _currentPath;
//   bool _isRecording = false;
//   bool _isPaused = false;
//   Function()? onCallStarted; // callback pause
//   Function()? onCallEnded; // callback resume

//   // for UI waveform
//   final StreamController<double> _dbController = StreamController.broadcast();

//   Stream<double> get decibelStream => _dbController.stream;

//   RecorderService._(this.chunkMs);

//   void setCallHandlers({Function()? onCallStarted, Function()? onCallEnded}) {
//     this.onCallStarted = onCallStarted;
//     this.onCallEnded = onCallEnded;
//   }

//   static Future<RecorderService> create({int chunkMs = 2000}) async {
//     final instance = RecorderService._(chunkMs);
//     instance.baseDir = await getTemporaryDirectory();
//     return instance;
//   }

//   Future<bool> _ensurePermission() async {
//     var mic = await Permission.microphone.request();
//     return mic.isGranted;
//   }

//   String _newChunkPath() {
//     final id = uuid.v4();
//     return "${baseDir.path}/chunk_${id}.wav";
//   }

//   /// Start PCM recording that rotates a WAV file every chunkMs.
//   Stream<String> startRecordingStream() async* {
//     if (_isRecording) return;

//     if (!await _ensurePermission()) {
//       throw Exception("Microphone permission not granted");
//     }

//     _controller = StreamController<String>();

//     // Start PCM stream (16-bit)
//     final stream = await _recorder.startStream(
//       const RecordConfig(
//         encoder: AudioEncoder.pcm16bits,
//         sampleRate: 16000,
//         numChannels: 1,
//       ),
//     );

//     _isRecording = true;
//     _startCallListener();

//     // Create first chunk file
//     _currentPath = _newChunkPath();
//     _currentSink = File(_currentPath!).openWrite();

//     // Rotate chunks every X ms
//     _timer = Timer.periodic(Duration(milliseconds: chunkMs), (_) async {
//       if (!_isRecording) return;

//       // Close current chunk
//       await _currentSink?.close();
//       _controller?.add(_currentPath!);

//       // Start new chunk
//       _currentPath = _newChunkPath();
//       _currentSink = File(_currentPath!).openWrite();
//     });

//     // Write PCM frames continuously
//     stream.listen(
//       (Uint8List data) {
//         if (!_isPaused) {
//           // Apply gain safely to PCM16 data
//           final processedData = _applyGainWithLimiter(data, _gain);
//           _currentSink?.add(processedData);

//           // calculate decibel from PCM
//           final db = _calculateDB(processedData);
//           _dbController.add(db);
//         }
//       },
//       onDone: () async {
//         await _currentSink?.close();
//         if (_currentPath != null) {
//           _controller?.add(_currentPath!);
//         }
//         await _controller?.close();
//       },
//       onError: (e) {
//         print("STREAM ERROR: $e");
//       },
//     );

//     yield* _controller!.stream;
//   }

//   Future<void> pause() async {
//     if (!_isRecording || _isPaused) return;

//     _isPaused = true;

//     // Stop rotating chunks while paused
//     _timer?.cancel();
//     _timer = null;

//     print("Recorder paused");
//   }

//   Future<void> resume() async {
//     if (!_isRecording || !_isPaused) return;

//     _isPaused = false;

//     // Resume chunk rotation
//     _timer = Timer.periodic(Duration(milliseconds: chunkMs), (_) async {
//       if (!_isRecording || _isPaused) return;

//       // Close previous chunk and rotate
//       await _currentSink?.close();
//       _controller?.add(_currentPath!);

//       _currentPath = _newChunkPath();
//       _currentSink = File(_currentPath!).openWrite();
//     });

//     print("Recorder resumed");
//   }

//   Future<void> _startCallListener() async {
//     final status = await Permission.phone.request();
//     print("status: $status");
//     if (!status.isGranted) {
//       print("Phone state permission not granted");
//       return;
//     }
//     _callSub = PhoneState.stream.listen((event) async {
//       print("event: ${event.status}");
//       if (event.status == PhoneStateStatus.CALL_INCOMING ||
//           event.status == PhoneStateStatus.CALL_STARTED) {
//         print("Call detected");
//         onCallStarted?.call();
//       }

//       if (event.status == PhoneStateStatus.CALL_ENDED) {
//         print("Call ended");
//         onCallEnded?.call();
//       }
//     });
//   }

//   /// Set gain (0.1 .. 1.0 recommended)
//   void setGain(double value) {
//     _gain = value.clamp(0.1, 2.0);
//   }

//   Future<void> stop() async {
//     if (!_isRecording) return;

//     _callSub?.cancel();
//     _callSub = null;

//     _isRecording = false;

//     await _recorder.stop();

//     _timer?.cancel();
//     _timer = null;

//     await _currentSink?.close();
//     _currentSink = null;

//     if (_currentPath != null) {
//       _controller?.add(_currentPath!);
//     }

//     await _controller?.close();
//     _controller = null;
//   }

//   double _calculateDB(Uint8List pcm) {
//     if (pcm.isEmpty) return 0;

//     double sum = 0;

//     // PCM 16-bit samples
//     final bytes = pcm.buffer.asByteData();
//     final sampleCount = pcm.length ~/ 2;
//     for (int i = 0; i < pcm.length; i += 2) {
//       final sample = bytes.getInt16(i, Endian.little).toDouble();
//       sum += sample * sample;
//     }

//     final rms = math.sqrt(sum / (sampleCount == 0 ? 1 : sampleCount));
//     final db = 20 * math.log(rms / 32768.0) / math.ln10;

//     if (db.isNaN || db.isInfinite) {
//       return 0;
//     }

//     return db;
//   }

//   Uint8List _applyGainWithLimiter(Uint8List data, double gain) {
//     final inBytes = data.buffer.asByteData();
//     final out = Uint8List(data.length);
//     final outBytes = out.buffer.asByteData();

//     const double maxSample = 32767.0;

//     // SAFE gain (prevent harsh boost of noise)
//     double safeGain = gain.clamp(0.1, 1.6);

//     // Limiter params
//     const double threshold = 24000.0; // lower threshold = MUCH cleaner
//     const double knee = 3000.0;

//     for (int i = 0; i < data.length; i += 2) {
//       int sample = inBytes.getInt16(i, Endian.little);

//       // --- APPLY SAFE GAIN ---
//       double x = sample * safeGain;

//       double absX = x.abs();

//       // --- CLEAN ZONE ---
//       if (absX <= threshold) {
//         outBytes.setInt16(
//           i,
//           x.clamp(-maxSample, maxSample).round(),
//           Endian.little,
//         );
//         continue;
//       }

//       // --- SOFT KNEE LIMITING ---
//       double exceeded = absX - threshold;
//       double ratio = (exceeded / knee).clamp(0.0, 1.0);

//       // Smooth curve: 0→1 without sharp edges
//       double limited = threshold + knee * (ratio * ratio * 0.5);

//       // Keep original sign
//       limited = x.isNegative ? -limited : limited;

//       // Final safety clamp
//       outBytes.setInt16(
//         i,
//         limited.clamp(-maxSample, maxSample).round(),
//         Endian.little,
//       );
//     }

//     return out;
//   }

//   void dispose() {
//     _recorder.dispose();
//     try {
//       _dbController.close();
//     } catch (_) {}
//   }
// }
