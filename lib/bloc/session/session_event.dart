part of 'session_bloc.dart';

abstract class SessionEvent extends Equatable {}

class LoadInitialSesionListEvent extends SessionEvent {
  final String patientId;
  LoadInitialSesionListEvent({required this.patientId});
  @override
  List<Object?> get props => [patientId];
}

class RefreshSessionListEvet extends SessionEvent {
  final String patientId;
  RefreshSessionListEvet({required this.patientId});
  @override
  List<Object?> get props => [patientId];
}
