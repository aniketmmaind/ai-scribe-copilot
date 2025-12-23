part of 'login_bloc.dart';

class LoginState extends Equatable {
  final LoginStatus status;
  final User? userModel;
  final String? message;
  final String? email;
  final String? password;

  const LoginState({
    this.status = LoginStatus.initial,
    this.userModel,
    this.message,
    this.email,
    this.password,
  });

  LoginState copyWith({
    LoginStatus? status,
    User? userModel,
    String? message,
    String? email,
    String? password,
  }) {
    return LoginState(
      status: status ?? this.status,
      userModel: userModel ?? this.userModel,
      message: message ?? this.message,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [status, userModel, message, email, password];
}
