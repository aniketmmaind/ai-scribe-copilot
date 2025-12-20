part of '../login_screen.dart';

class EmailTextfieldWidget extends StatelessWidget {
  final FocusNode focusNode;

  const EmailTextfieldWidget({super.key, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return AppTextFieldUtil(
      focusNode: focusNode,
      label: AppLocalizations.of(context)!.emailTxt,
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.enterEmailTxt;
        }
        return null;
      },
      onChanged: (email) {
        context.read<LoginBloc>().add(EmailChangeEvent(email: email));
      },
    );
  }
}
