import 'package:equatable/equatable.dart';

abstract class RecorderEvent extends Equatable {}

class StartRecording extends RecorderEvent {
  final String patientId;
  final String userId;
  final String patientName;

  StartRecording({
    required this.patientId,
    required this.patientName,
    required this.userId,
  });
  @override
  List<Object?> get props => [patientId, userId, patientName];
}

class StopRecording extends RecorderEvent {
  @override
  List<Object?> get props => [];
}

class PauseRecording extends RecorderEvent {
  final bool? isFromCall;
  PauseRecording({this.isFromCall = false});
  @override
  List<Object?> get props => [isFromCall];
}

class ResumeRecording extends RecorderEvent {
  final bool? isFromCall;
  ResumeRecording({this.isFromCall = false});
  @override
  List<Object?> get props => [isFromCall];
}

class TickTimer extends RecorderEvent {
  @override
  List<Object?> get props => [];
}

class GenerateUploadChunkEvent extends RecorderEvent {
  final String path;

  GenerateUploadChunkEvent({required this.path});

  @override
  List<Object?> get props => [path];
}

class AutoDrainQueueEvent extends RecorderEvent {
  @override
  List<Object?> get props => [];
}

class UpdateWaveform extends RecorderEvent {
  final double? db;
  UpdateWaveform({required this.db});
  @override
  List<Object?> get props => [db];
}

class SetGainEvent extends RecorderEvent {
  final double gain;
  SetGainEvent({required this.gain});
  @override
  List<Object?> get props => [gain];
}

class TranscriptReceived extends RecorderEvent {
  final String text;
  final bool isFinal;

  TranscriptReceived({required this.text, required this.isFinal});

  @override
  List<Object?> get props => [text, isFinal];
}
