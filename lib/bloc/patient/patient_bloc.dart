import 'dart:async';
import 'dart:developer';

import 'package:ai_scribe_copilot/models/patients/patients_list_model.dart';
import 'package:ai_scribe_copilot/repositories/patient/fetch_patient_list_repo.dart';
import 'package:ai_scribe_copilot/services/session_manager/session_controller.dart';
import 'package:ai_scribe_copilot/utils/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'patient_event.dart';
part 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final _fetchPatientListRepo = FetchPatientsRepo();
  PatientBloc() : super(PatientState()) {
    on<LoadInitialPatientListEvent>(_onLoadInitialPatientList);
    on<AddPatientToListEvent>(_onAddPatientToList);
    on<RefreshPatientListEvent>(_onRefreshPatientList);
  }

  FutureOr<void> _onLoadInitialPatientList(
    LoadInitialPatientListEvent event,
    Emitter<PatientState> emit,
  ) async {
    emit(
      state.copyWith(patientStatus: PatientStatus.loading, message: "Loading"),
    );
    try {
      final patientListModel = await _fetchPatientListRepo.fetchPatientByUserId(
        {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${SessionController.authToken}",
        },
        {"userId": SessionController.user!.id.toString()},
      );

      emit(
        state.copyWith(
          patientStatus: PatientStatus.success,
          message: "Successfully Fetch...",
          patientListModel: patientListModel,
        ),
      );
    } catch (e) {
      log("exp: ${e.toString()}");
      emit(
        state.copyWith(
          patientStatus: PatientStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onAddPatientToList(
    AddPatientToListEvent event,
    Emitter<PatientState> emit,
  ) {
    emit(state.copyWith(patientStatus: PatientStatus.loading));
    final updatedList = List<Patient>.from(state.patientListModel!.patients)
      ..add(event.patient);

    emit(
      state.copyWith(
        patientStatus: PatientStatus.success,
        patientListModel: PatientListModel(patients: updatedList),
      ),
    );
  }

  FutureOr<void> _onRefreshPatientList(
    RefreshPatientListEvent event,
    Emitter<PatientState> emit,
  ) {
    add(LoadInitialPatientListEvent());
  }
}
