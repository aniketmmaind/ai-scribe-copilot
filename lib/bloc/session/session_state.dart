part of 'session_bloc.dart';

class SessionState extends Equatable {
  final SessionStatus sessionStatus;
  final SessionModel? sessionModel;
  final String? message;

  const SessionState({
    this.sessionStatus = SessionStatus.initial,
    this.sessionModel,
    this.message,
  });

  SessionState copyWith({
    SessionStatus? sessionStatus,
    SessionModel? sessionModel,
    String? message,
  }) {
    return SessionState(
      sessionStatus: sessionStatus ?? this.sessionStatus,
      sessionModel: sessionModel ?? this.sessionModel,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [sessionStatus, sessionModel, message];
}
