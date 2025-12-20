import 'package:ai_scribe_copilot/repositories/patient/fetch_patient_list_repo.dart';
import 'package:ai_scribe_copilot/services/session_manager/session_controller.dart';
import 'package:ai_scribe_copilot/utils/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/patients/patient_detail_model.dart';
part 'patient_detail_event.dart';
part 'patient_details_state.dart';

class PatientDetailBloc extends Bloc<PatientDetailEvent, PatientDetailState> {
  final _fetchPatientDetails = FetchPatientsRepo();
  final Map<String, PatientDetailModel> _cache = {};
  PatientDetailBloc() : super(const PatientDetailState()) {
    on<FetchtPatientDetailsEvent>(_onGetPatientDetails);
  }

  Future<void> _onGetPatientDetails(
    FetchtPatientDetailsEvent event,
    Emitter<PatientDetailState> emit,
  ) async {
    final id = event.patientId;

    emit(
      state.copyWith(status: PatientDetailsStatus.loading, message: "Loading"),
    );
    try {
      //first check if it is loaded by user prev or not
      //if then pass _cache data {patientDetailModel}
      //else call API fetchPatientByPatientId()
      if (_cache.containsKey(id)) {
        emit(
          state.copyWith(
            status: PatientDetailsStatus.success,
            message: "Successfully Fetch...",
            patientDetailModel: _cache[id],
          ),
        );
      }
      final patientListModel = await _fetchPatientDetails
          .fetchPatientByPatientId({
            "Content-Type": "application/json",
            "Authorization": "Bearer ${SessionController.authToken}",
          }, id);
      // Store new resp in cache
      _cache[id] = patientListModel;
      emit(
        state.copyWith(
          status: PatientDetailsStatus.success,
          message: "Successfully Fetch...",
          patientDetailModel: patientListModel,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PatientDetailsStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }
}
