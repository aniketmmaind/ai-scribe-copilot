part of 'add_patient_bloc.dart';

class AddPatientState extends Equatable {
  final PatientStatus status;
  final PatientDetailModel patientRequestModel;
  final AddedPatientModel? addedPatientModel;
  final String? message;
  // to rebuild all TextFields
  final int formKeyId;

  const AddPatientState({
    this.status = PatientStatus.initial,
    required this.patientRequestModel,
    this.addedPatientModel,
    this.message,
    this.formKeyId = 0,
  });

  AddPatientState copyWith({
    PatientStatus? status,
    PatientDetailModel? patientRequestModel,
    AddedPatientModel? addedPatientModel,
    String? message,
    int? formKeyId,
  }) {
    return AddPatientState(
      status: status ?? this.status,
      patientRequestModel: patientRequestModel ?? this.patientRequestModel,
      addedPatientModel: addedPatientModel ?? this.addedPatientModel,
      message: message ?? this.message,
      formKeyId: formKeyId ?? this.formKeyId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    patientRequestModel,
    addedPatientModel,
    message,
    formKeyId,
  ];
}
