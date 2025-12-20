import 'dart:async';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/session_manager/session_controller.dart';
part 'lang_theme_selector_event.dart';
part 'lang_theme_selector_state.dart';

class LanguageThemeSelectorBloc
    extends Bloc<LanguageThemeSelectorEvent, LanguageThemeSelectorState> {
  final SessionController session = SessionController();

  LanguageThemeSelectorBloc()
    : super(
        const LanguageThemeSelectorState(
          locale: Locale('en'),
          themeMode: ThemeMode.light,
        ),
      ) {
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<LoadSavedLanguageEvent>(_onLoadSavedLanguage);
    on<ChangeThemeEvent>(_onChangeTheme);
    on<LoadSavedThemeEvent>(_onLoadSavedTheme);
  }

  Future<void> _onLoadSavedLanguage(
    LoadSavedLanguageEvent event,
    Emitter<LanguageThemeSelectorState> emit,
  ) async {
    final code = await session.getLanguageCode();
    emit(state.copyWith(locale: Locale(code)));
  }

  Future<void> _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<LanguageThemeSelectorState> emit,
  ) async {
    // Save language code
    await session.saveLanguageCode(event.locale.languageCode);
    emit(state.copyWith(locale: event.locale));
  }

  Future<void> _onLoadSavedTheme(
    LoadSavedThemeEvent event,
    Emitter<LanguageThemeSelectorState> emit,
  ) async {
    final mode = await session.getTheme();
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> _onChangeTheme(
    ChangeThemeEvent event,
    Emitter<LanguageThemeSelectorState> emit,
  ) async {
    // Save language code
    await session.saveTheme(event.themeMode);
    emit(state.copyWith(themeMode: event.themeMode));
  }
}
