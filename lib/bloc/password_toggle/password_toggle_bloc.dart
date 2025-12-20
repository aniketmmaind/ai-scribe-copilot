import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'password_toggle_event.dart';
part 'password_toggle_state.dart';

class PasswordToggleBloc extends Bloc<PasswordEvent, PasswordToggleState> {
  PasswordToggleBloc() : super(const PasswordToggleState(isPasswordVisible: false)) {
    on<TogglePasswordVisibilityEvent>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    });
  }
}
