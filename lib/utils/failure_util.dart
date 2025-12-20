import 'package:flutter/material.dart';

class FailureUtil extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;

  const FailureUtil({
    super.key,
    this.title = "Nothing here yet",
    this.message = "Try Sometime later...",
    this.icon = Icons.error_outline_outlined,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(20),
      children: [
        SizedBox(height: 120),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 64, color: Colors.grey.shade400),

                const SizedBox(height: 16),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),

                if (actionText != null && onAction != null) ...[
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: onAction, child: Text(actionText!)),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
