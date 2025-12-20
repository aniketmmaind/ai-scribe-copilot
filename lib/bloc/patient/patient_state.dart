part of 'patient_bloc.dart';

class PatientState extends Equatable {
  final PatientStatus patientStatus;
  final PatientListModel? patientListModel;
  final String? message;

  const PatientState({
    this.patientStatus = PatientStatus.initial,
    this.patientListModel,
    this.message,
  });

  PatientState copyWith({
    PatientStatus? patientStatus,
    PatientListModel? patientListModel,
    String? message,
  }) {
    return PatientState(
      patientStatus: patientStatus ?? this.patientStatus,
      patientListModel: patientListModel ?? this.patientListModel,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [patientStatus, patientListModel, message];
}
