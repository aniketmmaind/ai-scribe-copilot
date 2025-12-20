import 'package:flutter/material.dart';

class AppTextFieldUtil extends StatelessWidget {
  final FocusNode focusNode;
  final String label;
  final IconData prefixIcon;
  final bool isPassword;
  final bool isMultiLine;
  final TextInputType keyboardType;
  final VoidCallback? onTogglePassword;
  final String? Function(String?)? validator;
  final ValueChanged? onChanged;
  final int formKeyId;
  const AppTextFieldUtil({
    super.key,
    required this.focusNode,
    required this.label,
    required this.prefixIcon,
    this.isPassword = false,
    this.isMultiLine = false,
    this.keyboardType = TextInputType.text,
    this.onTogglePassword,
    this.validator,
    this.onChanged,
    this.formKeyId = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Build a unique key for this field so it is recreated when formKeyId changes
    final fieldKey = ValueKey('$label-$formKeyId');
    return TextFormField(
      key: fieldKey,
      focusNode: focusNode,
      obscureText: isPassword,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      maxLines: isMultiLine ? 5 : 1,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        suffixIcon:
            onTogglePassword != null
                ? IconButton(
                  icon: Icon(
                    isPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: onTogglePassword,
                )
                : null,
        filled: true,

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
