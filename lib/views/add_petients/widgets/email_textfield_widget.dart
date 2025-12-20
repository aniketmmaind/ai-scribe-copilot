part of '../add_patients_screen.dart';

class EmailTextfieldWidget extends StatelessWidget {
  final int formKeyId;
  final FocusNode focusNode;
  const EmailTextfieldWidget({
    super.key,
    required this.focusNode,
    this.formKeyId = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextFieldUtil(
      focusNode: focusNode,
      formKeyId: formKeyId,
      label: AppLocalizations.of(context)!.emailTxt,
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => emailValidator(value, context),
      onChanged: (email) {
        context.read<AddPatientBloc>().add(EmailChangeEvent(email: email));
      },
    );
  }

  String? emailValidator(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.reqEmailTxt;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.emlValiTxt;
    }

    return null;
  }
}
