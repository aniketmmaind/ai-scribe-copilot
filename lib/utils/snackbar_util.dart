import 'package:flutter/material.dart';

class SnackbarUtil {
  static void showSnckBar(
    BuildContext context,
    String message, {
    bool showOnTop = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin:
            showOnTop
                ? EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context).size.height -
                      150, // Pushes it to the top
                  left: 10,
                  right: 10,
                )
                : null,
      ),
    );
  }
}
