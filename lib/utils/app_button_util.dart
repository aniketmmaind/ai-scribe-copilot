import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double borderRadius;
  final Color backgroundColor;
  final EdgeInsets padding;
  final TextStyle? textStyle;
  final String tooltipMsg;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.borderRadius = 14,
    this.backgroundColor = const Color(0xff4f3693),
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.textStyle,
    this.tooltipMsg = "",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Tooltip(
        message: tooltipMsg,
        triggerMode: TooltipTriggerMode.longPress,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: backgroundColor,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          onPressed: isLoading ? null : onPressed,
          child:
              isLoading
                  ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                  : Text(
                    text,
                    style:
                        textStyle ??
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
        ),
      ),
    );
  }
}
