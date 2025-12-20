import 'package:ai_scribe_copilot/utils/enums.dart';
import 'package:equatable/equatable.dart';

class RecorderState extends Equatable {
  final RecordingStatus status;
  final String? sessionId;
  final String? patientId;
  final Duration duration;
  final int chunkNum;
  final bool autoPause;
  final double currentDB;
  final List<double> waveform;
  final bool isLast;
  final String liveTranscript;
  final String? message;

  const RecorderState({
    required this.status,
    this.sessionId,
    this.patientId,
    required this.duration,
    this.chunkNum = 0,
    this.autoPause = false,
    this.currentDB = 0,
    this.isLast = false,
    this.liveTranscript = "",
    List<double>? waveform,
    this.message,
  }) : waveform = waveform ?? const [];

  RecorderState copyWith({
    RecordingStatus? status,
    String? sessionId,
    String? patientId,
    Duration? duration,
    int? chunkNum,
    bool? autoPause,
    double? currentDB,
    bool? isLast,
    String? liveTranscript,
    List<double>? waveform,
    String? message,
  }) {
    return RecorderState(
      status: status ?? this.status,
      sessionId: sessionId ?? this.sessionId,
      patientId: patientId ?? this.patientId,
      duration: duration ?? this.duration,
      chunkNum: chunkNum ?? this.chunkNum,
      autoPause: autoPause ?? this.autoPause,
      currentDB: currentDB ?? this.currentDB,
      isLast: isLast ?? this.isLast,
      liveTranscript: liveTranscript ?? this.liveTranscript,
      waveform: waveform ?? this.waveform,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    sessionId,
    patientId,
    duration,
    chunkNum,
    autoPause,
    currentDB,
    isLast,
    liveTranscript,
    waveform,
    message,
  ];
}
