part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginButtonPressed extends LoginEvent {}

class EmailChangeEvent extends LoginEvent {
  final String email;
  const EmailChangeEvent({required this.email});
  @override
  List<Object> get props => [email];
}

class PasswordChangeEvent extends LoginEvent {
  final String password;
  const PasswordChangeEvent({required this.password});
  @override
  List<Object> get props => [password];
}
