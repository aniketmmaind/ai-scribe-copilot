part of '../add_patients_screen.dart';

class BackgroundTextfieldWidget extends StatelessWidget {
  final FocusNode focusNode;
  final int formKeyId;
  const BackgroundTextfieldWidget({
    super.key,
    required this.focusNode,
    this.formKeyId = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextFieldUtil(
      formKeyId: formKeyId,
      focusNode: focusNode,
      label: AppLocalizations.of(context)!.bgTxt,
      prefixIcon: Icons.info_outline,
      keyboardType: TextInputType.emailAddress,
      onChanged: (background) {
        context.read<AddPatientBloc>().add(
          BackgroundChangeEvent(background: background),
        );
      },
    );
  }
}
