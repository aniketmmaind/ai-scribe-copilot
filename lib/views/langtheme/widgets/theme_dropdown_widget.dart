import 'package:ai_scribe_copilot/bloc/lang_theme_selector/lang_selector_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../utils/dropdown_util.dart';

class ThemeDropdownWidget extends StatelessWidget {
  const ThemeDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageThemeSelectorBloc, LanguageThemeSelectorState>(
      builder: (context, state) {
        return DropdownUtil<ThemeMode>(
          value: state.themeMode!,
          items: [ThemeMode.system, ThemeMode.light, ThemeMode.dark],
          labelBuilder:
              (theme) =>
                  theme == ThemeMode.system
                      ? AppLocalizations.of(context)!.systemTxt
                      : theme == ThemeMode.light
                      ? AppLocalizations.of(context)!.lightTxt
                      : AppLocalizations.of(context)!.darkTxt,
          onChanged: (value) {
            context.read<LanguageThemeSelectorBloc>().add(
              ChangeThemeEvent(value!),
            );
          },
        );
      },
    );
  }
}
