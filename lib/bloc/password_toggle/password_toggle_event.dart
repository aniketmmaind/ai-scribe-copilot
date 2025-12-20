part of 'password_toggle_bloc.dart';

abstract class PasswordEvent extends Equatable {
  const PasswordEvent();

  @override
  List<Object?> get props => [];
}

class TogglePasswordVisibilityEvent extends PasswordEvent {}
