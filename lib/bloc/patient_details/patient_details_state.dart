part of 'patient_detail_bloc.dart';

class PatientDetailState extends Equatable {
  final PatientDetailsStatus status;
  final PatientDetailModel? patientDetailModel;
  final String? message;

  const PatientDetailState({
    this.status = PatientDetailsStatus.initial,
    this.patientDetailModel,
    this.message,
  });

  PatientDetailState copyWith({
    PatientDetailsStatus? status,
    PatientDetailModel? patientDetailModel,
    String? message,
  }) {
    return PatientDetailState(
      status: status ?? this.status,
      patientDetailModel: patientDetailModel ?? this.patientDetailModel,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, patientDetailModel, message];
}
