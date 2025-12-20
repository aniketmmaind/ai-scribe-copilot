import 'package:ai_scribe_copilot/bloc/lang_theme_selector/lang_selector_bloc.dart';
import 'package:ai_scribe_copilot/services/haptic_manager/haptic_controller.dart';
import 'package:ai_scribe_copilot/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageThemeSelectorBloc, LanguageThemeSelectorState>(
      builder: (context, state) {
        return Switch(
          value: _isDark(state.themeMode!),
          onChanged: (value) {
          
            HapticFeedbackManager.trigger(HapticType.success);
            ThemeMode appTheme = (value) ? ThemeMode.dark : ThemeMode.light;
            context.read<LanguageThemeSelectorBloc>().add(
              ChangeThemeEvent(appTheme),
            );
          },
        );
      },
    );
  }

  bool _isDark(ThemeMode themeMode) {
    switch (themeMode) {
      case (ThemeMode.dark):
        return true;
      case (ThemeMode.light):
        return false;
      default:
        return false;
    }
  }
}
