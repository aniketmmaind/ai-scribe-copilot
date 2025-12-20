import 'package:flutter/material.dart';

class DropdownUtil<T> extends StatelessWidget {
  final T value;
  final List<T> items;

  /// How each item should be shown as text in dropdown
  final String Function(T) labelBuilder;

  /// Returns selected item
  final ValueChanged<T?> onChanged;

  /// Optional styling controls
  final double borderRadius;
  final EdgeInsets padding;

  const DropdownUtil({
    super.key,
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 26,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          dropdownColor: Theme.of(context).scaffoldBackgroundColor,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
          items:
              items
                  .map(
                    (e) => DropdownMenuItem<T>(
                      value: e,
                      child: Text(labelBuilder(e)),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
