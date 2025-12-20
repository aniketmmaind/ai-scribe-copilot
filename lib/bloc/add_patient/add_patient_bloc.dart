import 'dart:async';
import 'package:ai_scribe_copilot/models/patients/patient_detail_model.dart';
import 'package:ai_scribe_copilot/repositories/add_patient/add_patient_byuserid_repo.dart';
import 'package:ai_scribe_copilot/utils/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/patients/added_patient_model.dart';
import '../../services/session_manager/session_controller.dart';

part 'add_patient_event.dart';
part 'add_patient_state.dart';

class AddPatientBloc extends Bloc<AddPatientEvent, AddPatientState> {
  final _addPatientByUserIdRepo = AddPatientByuseridRepo();
  AddPatientBloc()
    : super(
        AddPatientState(
          patientRequestModel: PatientDetailModel(pronoun: "She/Her"),
        ),
      ) {
    on<EmailChangeEvent>(_onEmailChange);
    on<FullNameChangeEvent>(_onFullNameChanged);
    on<BackgroundChangeEvent>(_onBackgroundChanged);
    on<MediHistChangeEvent>(_onMediHistChanged);
    on<FamilyHistChangeEvent>(_onFamilyHistChanged);
    on<SocialHistChangeEvent>(_onSocialHistChanged);
    on<PrevHistChangeEvent>(_onPrevHistChanged);
    on<PronounChangeEvent>(_onPronounChanged);
    on<AddPatientsButtonPressed>(_onAddPatient);
    on<ClearFieldAfterSuccess>(_onClearFeildAfterSuccess);
  }

  _onEmailChange(EmailChangeEvent event, Emitter<AddPatientState> emit) {
    emit(
      state.copyWith(
        patientRequestModel: state.patientRequestModel.copyWith(
          email: event.email,
        ),
      ),
    );
  }

  FutureOr<void> _onFullNameChanged(
    FullNameChangeEvent event,
    Emitter<AddPatientState> emit,
  ) {
    emit(
      state.copyWith(
        patientRequestModel: state.patientRequestModel.copyWith(
          name: event.name,
        ),
      ),
    );
  }

  FutureOr<void> _onBackgroundChanged(
    BackgroundChangeEvent event,
    Emitter<AddPatientState> emit,
  ) {
    emit(
      state.copyWith(
        patientRequestModel: state.patientRequestModel.copyWith(
          background: event.background,
        ),
      ),
    );
  }

  FutureOr<void> _onMediHistChanged(
    MediHistChangeEvent event,
    Emitter<AddPatientState> emit,
  ) {
    emit(
      state.copyWith(
        patientRequestModel: state.patientRequestModel.copyWith(
          mediHist: event.mediHist,
        ),
      ),
    );
  }

  FutureOr<void> _onFamilyHistChanged(
    FamilyHistChangeEvent event,
    Emitter<AddPatientState> emit,
  ) {
    emit(
      state.copyWith(
        patientRequestModel: state.patientRequestModel.copyWith(
          familyHist: event.familyHist,
        ),
      ),
    );
  }

  FutureOr<void> _onSocialHistChanged(
    SocialHistChangeEvent event,
    Emitter<AddPatientState> emit,
  ) {
    emit(
      state.copyWith(
        patientRequestModel: state.patientRequestModel.copyWith(
          socialHist: event.socialHist,
        ),
      ),
    );
  }

  FutureOr<void> _onPrevHistChanged(
    PrevHistChangeEvent event,
    Emitter<AddPatientState> emit,
  ) {
    emit(
      state.copyWith(
        patientRequestModel: state.patientRequestModel.copyWith(
          prevHist: event.prevHist,
        ),
      ),
    );
  }

  FutureOr<void> _onPronounChanged(
    PronounChangeEvent event,
    Emitter<AddPatientState> emit,
  ) {
    emit(
      state.copyWith(
        patientRequestModel: state.patientRequestModel.copyWith(
          pronoun: event.pronoun,
        ),
      ),
    );
  }

  FutureOr<void> _onAddPatient(
    AddPatientsButtonPressed event,
    Emitter<AddPatientState> emit,
  ) async {
    emit(state.copyWith(status: PatientStatus.loading, message: "Loading"));
    try {
      final response = await _addPatientByUserIdRepo.addPatientByUserId(
        {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${SessionController.authToken}",
        },
        state.patientRequestModel
            .copyWith(userId: SessionController.user!.id)
            .toJson(),
      );

      emit(
        state.copyWith(
          status: PatientStatus.success,
          addedPatientModel: response,
        ),
      );

      ///  CLEAR THE FORM
      add(ClearFieldAfterSuccess());
    } catch (e) {
      emit(
        state.copyWith(status: PatientStatus.failure, message: e.toString()),
      );
    }
  }

  FutureOr<void> _onClearFeildAfterSuccess(
    ClearFieldAfterSuccess event,
    Emitter<AddPatientState> emit,
  ) {
    emit(
      state.copyWith(
        /// Reset model to initial values
        patientRequestModel: PatientDetailModel(
          name: "",
          userId: "",
          pronoun: "She/Her",
          email: "",
          background: "",
          mediHist: "",
          familyHist: "",
          socialHist: "",
          prevHist: "",
        ),
        formKeyId: state.formKeyId + 1,
      ),
    );
  }
}
