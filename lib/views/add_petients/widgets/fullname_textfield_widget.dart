part of '../add_patients_screen.dart';

class FullnameTextfieldWidget extends StatelessWidget {
  final FocusNode focusNode;
  final int formKeyId;

  const FullnameTextfieldWidget({
    super.key,
    required this.focusNode,
    this.formKeyId = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextFieldUtil(
      focusNode: focusNode,
      formKeyId: formKeyId,
      label: AppLocalizations.of(context)!.fullnameTxt,
      prefixIcon: Icons.person_outline,
      validator: (v) {
        if (v == null || v.isEmpty) {
          return AppLocalizations.of(context)!.reqNameTxt;
        }
        return null;
      },
      onChanged: (name) {
        context.read<AddPatientBloc>().add(FullNameChangeEvent(name: name));
      },
    );
  }
}
