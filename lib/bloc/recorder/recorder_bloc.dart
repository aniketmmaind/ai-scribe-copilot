import 'dart:async';
import 'dart:developer';
import 'package:ai_scribe_copilot/bloc/recorder/recorder_event.dart';
import 'package:ai_scribe_copilot/bloc/recorder/recorder_state.dart';
import 'package:ai_scribe_copilot/repositories/recording/recording_session_repo.dart';
import 'package:ai_scribe_copilot/services/haptic_manager/haptic_controller.dart';
import 'package:ai_scribe_copilot/services/storage/local_db.dart';
import 'package:ai_scribe_copilot/services/permission_manager/permission_controller.dart';
import 'package:ai_scribe_copilot/services/recorder_manager/recorder_service.dart';
import 'package:ai_scribe_copilot/services/upload_manager/upload_controller.dart';
import 'package:ai_scribe_copilot/utils/date_time_formater_util.dart';
import 'package:ai_scribe_copilot/utils/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import '../../models/pending_chunk/pending_chunk_model.dart';
import '../../services/notification_manager/notification_service.dart';
import '../../services/session_manager/session_controller.dart';
import '../../services/transcript_manager/deepgram_streaming_service.dart';

class RecorderBloc extends Bloc<RecorderEvent, RecorderState> {
  Timer? _timer;
  final _recodingSessionRepo = RecordingSessionRepo();
  late RecorderService _recorder;
  final _uploadManager = UploadController();
  late DeepgramStreamingService _deepgram;
  // late OnDeviceSpeechController _onDeviceSpeech; // to use Native API for speech to text i.e.
  //for transcript uncomment all _onDeviceSpeech obj and comment _onDeviceSpeech.
  //but it is restricted in release apk mic can't give access to both services

  RecorderBloc()
    : super(
        RecorderState(status: RecordingStatus.idle, duration: Duration.zero),
      ) {
    on<StartRecording>(_onStart);
    on<StopRecording>(_onStop);
    on<PauseRecording>(_onPause);
    on<ResumeRecording>(_onResume);
    on<GenerateUploadChunkEvent>(_generateUploadChunk);
    on<TickTimer>(_onTick);
    on<UpdateWaveform>(_updateWaveform);
    on<AutoDrainQueueEvent>(_autoDrainQueue);
    on<SetGainEvent>(_setGain);
    on<TranscriptReceived>(_onTranscriptReceived);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => add(TickTimer()));
  }

  void _onStart(StartRecording event, Emitter<RecorderState> emit) async {
    emit(state.copyWith(status: RecordingStatus.loading));
    HapticFeedbackManager.trigger(HapticType.light);

    try {
      if (kIsWeb) {
        emit(
          state.copyWith(
            message:
                "You are running on Web. Audio chunks will not be uploaded or saved locally.",
            status: RecordingStatus.error,
          ),
        );
        return;
      }
      final hasMicPermission = await PermissionController.ensureMicPermission();
      final hasPhonePermission =
          await PermissionController.ensurePhonePermission();
      final hasNotificationPermission =
          await PermissionController.ensureNotificationPermission();
      if (!hasMicPermission) {
        emit(
          state.copyWith(
            status: RecordingStatus.error,
            message: "Microphone permission is required to start recording",
          ),
        );
        return;
      }
      if (!hasPhonePermission) {
        emit(
          state.copyWith(
            status: RecordingStatus.error,
            message:
                "Phone call permission is required to start recording, for functionality",
          ),
        );
        return;
      }
      if (!hasNotificationPermission) {
        emit(
          state.copyWith(
            status: RecordingStatus.error,
            message: "Notificatoion Permission is required for functionality",
          ),
        );
        return;
      }

      final sessionId = await _recodingSessionRepo.createSession(
        {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${SessionController.authToken}",
        },
        {
          'patientId': event.patientId,
          'userId': event.userId,
          'patientName': event.patientName,
          'status': 'recording',
          'startTime': DateTime.now().toUtc().toIso8601String(),
          'templateId': "temp-001",
        },
      );

      // _onDeviceSpeech = OnDeviceSpeechController();
      // await _onDeviceSpeech.init();

      _recorder = await RecorderService.create(sessionId: sessionId);
      _deepgram = DeepgramStreamingService(dotenv.env['DEEPGRAM_API_KEY']!);

      _deepgram.onTranscript = (text, isFinal) {
        add(TranscriptReceived(text: text, isFinal: isFinal));
      };

      _recorder.onPcmFrame = (pcm) {
        _deepgram.sendPcm(pcm);
      };

      _deepgram.connect();
      _recorder.decibelStream.listen((db) {
        add(UpdateWaveform(db: db));
      });
      //add resume and pause to set method for pause
      //and resume at phone call.
      _recorder.setCallHandlers(
        onCallEnded: () => add(ResumeRecording(isFromCall: true)),
        onCallStarted: () => add(PauseRecording(isFromCall: true)),
      );
      final stream = _recorder.startRecordingStream();
      emit(
        state.copyWith(
          status: RecordingStatus.recording,
          sessionId: sessionId,
          patientId: event.patientId,
          duration: Duration.zero,
          isLast: false,
          chunkNum: 0,
          liveTranscript: "",
          waveform: [],
        ),
      );
      // _onDeviceSpeech.start(
      //   onResult: (text, isFinal) {
      //     // debugPrint("text: $text");
      //     // LIVE PREVIEW
      //     add(TranscriptReceived(text: text, isFinal: isFinal));
      //   },
      // );

      stream.listen(
        (chunkPath) async {
          add(GenerateUploadChunkEvent(path: chunkPath));
        },
        onError: (e) {
          log('recording stream error $e');
        },
        onDone: () {
          log('recorder stream done');
        },
      );

      // Start Notification
      await NotificationService.showRecordingNotification(
        title: "Recording in progress",
        body: "Audio is being captured",
      );
      _startTimer();
    } catch (e) {
      log("_onStart error: ${e.toString()}");
      emit(
        state.copyWith(status: RecordingStatus.error, message: e.toString()),
      );
    }
  }

  void _onStop(StopRecording event, Emitter<RecorderState> emit) {
    HapticFeedbackManager.trigger(HapticType.error);

    _recorder.stop();
    _deepgram.close();
    // _onDeviceSpeech.cancel();
    _timer?.cancel();
    NotificationService.clear();
    emit(
      state.copyWith(
        status: RecordingStatus.stopped,
        duration: Duration.zero,
        waveform: [],
        isLast: true,
      ),
    );
  }

  void _onPause(PauseRecording event, Emitter<RecorderState> emit) {
    HapticFeedbackManager.trigger(HapticType.warning);

    _recorder.pause();
    _deepgram.close();
    // _onDeviceSpeech.stop();
    _timer?.cancel();

    bool isAutoPause = event.isFromCall == true;

    String duration = DateTimeFormaterUtil.formatDuration(state.duration);
    NotificationService.showRecordingNotification(
      title: "Recording paused: $duration",
      body: "Tap resume to continue",
    ); // ensures actions update
    emit(
      state.copyWith(status: RecordingStatus.paused, autoPause: isAutoPause),
    );
  }

  void _onResume(ResumeRecording event, Emitter<RecorderState> emit) async {
    _recorder.resume();
    HapticFeedbackManager.trigger(HapticType.light);
    _deepgram = DeepgramStreamingService(dotenv.env['DEEPGRAM_API_KEY']!);

    _deepgram.onTranscript = (text, isFinal) {
      add(TranscriptReceived(text: text, isFinal: isFinal));
    };

    _deepgram.connect(); // reconnect

    // Resume ON-DEVICE speech (LIVE PREVIEW) native
    // await _onDeviceSpeech.init();
    // _onDeviceSpeech.start(
    //   onResult: (text, isFinal) {
    //     add(TranscriptReceived(text: text, isFinal: isFinal));
    //   },
    // );

    emit(state.copyWith(status: RecordingStatus.recording, autoPause: false));
    _startTimer();
  }

  void _onTick(TickTimer event, Emitter<RecorderState> emit) {
    if (state.status == RecordingStatus.recording) {
      final newDuration = state.duration + Duration(seconds: 1);
      final text = DateTimeFormaterUtil.formatDuration(newDuration);

      NotificationService.showRecordingNotification(
        title: "Recording.. $text",
        body: "Recording inprogress..",
      );
      emit(state.copyWith(duration: newDuration));
    }
  }

  Future<void> _generateUploadChunk(
    GenerateUploadChunkEvent event,
    Emitter<RecorderState> emit,
  ) async {
    // chunkPath is local wav path
    int chunkNum = state.chunkNum;
    bool isLastChunck = state.isLast;

    // ---------- SAVE TO LOCAL DB ----------
    final pending = PendingChunkModel(
      id: const Uuid().v4(),
      sessionId: state.sessionId!,
      chunkNumber: chunkNum,
      localFilePath: event.path,
      gcsPath: "",
      publicUrl: "",
      mimeType: 'audio/wav',
      isLast: isLastChunck,
      liveTranscript: isLastChunck ? state.liveTranscript : "",
    );

    await LocalDb.instance.insert('pending_chunks', pending.toMap());
    _uploadManager.tryUploadNow(pending);

    emit(state.copyWith(chunkNum: chunkNum + 1));
  }

  FutureOr<void> _autoDrainQueue(
    AutoDrainQueueEvent event,
    Emitter<RecorderState> emit,
  ) {
    _uploadManager.autoDrainQueue();
  }

  FutureOr<void> _updateWaveform(
    UpdateWaveform event,
    Emitter<RecorderState> emit,
  ) {
    final db = event.db ?? 0.0;

    final updatedList = List<double>.from(state.waveform)..add(db);

    // keep only last 20 bars
    if (updatedList.length > 50) {
      updatedList.removeAt(0);
    }

    emit(state.copyWith(currentDB: db, waveform: updatedList));
  }

  FutureOr<void> _setGain(SetGainEvent event, Emitter<RecorderState> emit) {}

  FutureOr<void> _onTranscriptReceived(
    TranscriptReceived event,
    Emitter<RecorderState> emit,
  ) {
    if (event.isFinal) {
      final updated = ('${state.liveTranscript} ${event.text}').trim();

      emit(state.copyWith(liveTranscript: updated));
    }

    // if (event.isFinal) {
    // final segment → append
    // final updated = ('${state.liveTranscript} ${event.text}').trim();

    // emit(state.copyWith(liveTranscript: updated));
    // } else {
    // partial preview → UI only
    //   emit(state.copyWith(liveTranscript: event.text));
    // }
  }
}
