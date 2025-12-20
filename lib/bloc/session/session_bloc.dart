import 'dart:async';
import 'package:ai_scribe_copilot/repositories/session/fetch_session_list_repo.dart';
import 'package:ai_scribe_copilot/services/session_manager/session_controller.dart';
import 'package:ai_scribe_copilot/utils/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/session/session_model.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final _fetchSessionListRepo = FetchSessionRepo();
  SessionBloc() : super(SessionState()) {
    on<LoadInitialSesionListEvent>(_onLoadInitialSessionList);
    on<RefreshSessionListEvet>(_onRefreshSessionList);
  }

  FutureOr<void> _onLoadInitialSessionList(
    LoadInitialSesionListEvent event,
    Emitter<SessionState> emit,
  ) async {
    emit(
      state.copyWith(sessionStatus: SessionStatus.loading, message: "Loading"),
    );
    try {
      final sessionListModel = await _fetchSessionListRepo
          .fetchPatientSessionByPatientId({
            "Content-Type": "application/json",
            "Authorization": "Bearer ${SessionController.authToken}",
          }, event.patientId);
      emit(
        state.copyWith(
          sessionStatus: SessionStatus.success,
          message: "Successfully Fetch...",
          sessionModel: sessionListModel,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          sessionStatus: SessionStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onRefreshSessionList(
    RefreshSessionListEvet event,
    Emitter<SessionState> emit,
  ) {
    add(LoadInitialSesionListEvent(patientId: event.patientId));
  }
}
