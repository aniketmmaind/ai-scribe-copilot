import 'package:ai_scribe_copilot/utils/app_button_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContinueButtonWidget extends StatelessWidget {
  final void Function() onPressed;
  const ContinueButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: AppLocalizations.of(context)!.continueTxt,
      onPressed: onPressed,
    );
  }
}
