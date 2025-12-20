part of '../login_screen.dart';

class PasswordTextfieldWidget extends StatelessWidget {
  final FocusNode focusNode;
  const PasswordTextfieldWidget({super.key, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordToggleBloc, PasswordToggleState>(
      builder: (context, state) {
        return AppTextFieldUtil(
          focusNode: focusNode,
          label: AppLocalizations.of(context)!.passwordTxt,
          prefixIcon: Icons.lock_outline,
          isPassword: !state.isPasswordVisible,
          keyboardType: TextInputType.visiblePassword,
          onChanged: (password) {
            context.read<LoginBloc>().add(
              PasswordChangeEvent(password: password),
            );
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.enterPassTxt;
            }
            return null;
          },
          onTogglePassword: () {
            context.read<PasswordToggleBloc>().add(
              TogglePasswordVisibilityEvent(),
            );
          },
        );
      },
    );
  }
}
