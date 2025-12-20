part of 'patient_detail_bloc.dart';

abstract class PatientDetailEvent extends Equatable {}

class FetchtPatientDetailsEvent extends PatientDetailEvent {
  final String patientId;
  FetchtPatientDetailsEvent({required this.patientId});

  @override
  List<Object?> get props => [patientId];
}
