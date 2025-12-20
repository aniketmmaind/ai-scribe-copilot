part of '../add_patients_screen.dart';

class MultiTextfieldWidget extends StatelessWidget {
  final FocusNode focusNode;
  final String label;
  final IconData icon;
  final ThemeData theme;
  final ValueChanged? onChanged;
  final int formKeyId;
  const MultiTextfieldWidget({
    super.key,
    required this.focusNode,
    required this.label,
    required this.icon,
    required this.theme,
    this.onChanged,
    this.formKeyId = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),

        AppTextFieldUtil(
          focusNode: focusNode,
          formKeyId: formKeyId,
          label: label,
          prefixIcon: icon,
          isMultiLine: true,
          onChanged: onChanged,
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
