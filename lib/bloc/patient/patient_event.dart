part of 'patient_bloc.dart';

abstract class PatientEvent extends Equatable {}

class LoadInitialPatientListEvent extends PatientEvent {
  @override
  List<Object?> get props => [];
}

class AddPatientToListEvent extends PatientEvent {
  final Patient patient;
  AddPatientToListEvent(this.patient);
  @override
  List<Object?> get props => [patient];
}

class RefreshPatientListEvent extends PatientEvent {
  @override
  List<Object?> get props => [];
}
