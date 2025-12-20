import 'dart:convert';

import 'package:ai_scribe_copilot/repositories/login/login_user_repo.dart';
import 'package:ai_scribe_copilot/services/session_manager/session_controller.dart';
import 'package:ai_scribe_copilot/utils/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user/user_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final loginUserRepository = LoginUserRepo();

  LoginBloc() : super(const LoginState()) {
    on<EmailChangeEvent>(_onEmailChange);
    on<PasswordChangeEvent>(_onPasswordChange);
    on<LoginButtonPressed>(_onLoginPressed);
  }

  _onEmailChange(EmailChangeEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email));
  }

  _onPasswordChange(PasswordChangeEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onLoginPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final userModel = await loginUserRepository.loginUser(
        {"Content-Type": "application/json"},
        {"email": state.email, "password": state.password},
      );
      // Store auth_token,refresh_token and user pref in safe storage
      await SessionController().saveAuthToken("auth_token", userModel.token);
      await SessionController().saveRefreshToken(
        "refresh_token",
        userModel.refreshToken,
      );

      //store them to sequre storage
      await SessionController().setUserPreference(
        jsonEncode(userModel.user!.toJson()),
      );

      //to access user data like user's name , email, id
      await SessionController().getUserFromPreference();
      emit(
        state.copyWith(
          status: LoginStatus.success,
          userModel: userModel.user,
          message: userModel.message,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, message: e.toString()));
    }
  }
}
