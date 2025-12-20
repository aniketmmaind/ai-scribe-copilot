part of 'password_toggle_bloc.dart';

class PasswordToggleState extends Equatable {
  final bool isPasswordVisible;

  const PasswordToggleState({required this.isPasswordVisible});

  PasswordToggleState copyWith({bool? isPasswordVisible}) {
    return PasswordToggleState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [isPasswordVisible];
}
