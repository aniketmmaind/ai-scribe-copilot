import 'package:ai_scribe_copilot/bloc/lang_theme_selector/lang_selector_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/dropdown_util.dart';

class LangDropdownWidget extends StatelessWidget {
  const LangDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageThemeSelectorBloc, LanguageThemeSelectorState>(
      builder: (context, state) {
        return DropdownUtil<Locale>(
          value: state.locale!,
          items: [Locale('en'), Locale('hi')],
          labelBuilder: (loc) => loc.languageCode == 'en' ? 'English' : 'हिंदी',
          onChanged: (value) {
            context.read<LanguageThemeSelectorBloc>().add(
              ChangeLanguageEvent(value!),
            );
          },
        );
      },
    );
  }
}
