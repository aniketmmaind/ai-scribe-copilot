// import 'package:flutter/material.dart';

// /// Pronoun dropdown (reusable)
// class PronounDropdown extends StatelessWidget {
//   final List<String> _options = const ['She/Her', 'He/Him', 'They/Them', 'Prefer not to say', 'Other'];
//   final String value;
//   final ValueChanged<String> onChanged;

//   PronounDropdown({super.key, required this.value, required this.onChanged});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: theme.colorScheme.primary.withOpacity(0.08)),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: value,
//           isExpanded: true,
//           icon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.primary),
//           items: _options.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
//           onChanged: (v) {
//             if (v != null) onChanged(v);
//           },
//         ),
//       ),
//     );
//   }
// }

// /// Multi-line text area with label
// class MultiLineField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final String? hint;
//   final int maxLines;
//   final String? Function(String?)? validator;

//   const MultiLineField({
//     super.key,
//     required this.controller,
//     required this.label,
//     this.hint,
//     this.maxLines = 5,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Text(label, style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600)),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: controller,
//           validator: validator,
//           maxLines: maxLines,
//           keyboardType: TextInputType.multiline,
//           decoration: InputDecoration(
//             hintText: hint,
//             filled: true,
//             fillColor: theme.cardColor,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           ),
//         ),
//       ],
//     );
//   }
// }
