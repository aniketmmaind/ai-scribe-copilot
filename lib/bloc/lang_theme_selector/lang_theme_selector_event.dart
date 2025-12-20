part of 'lang_selector_bloc.dart';

abstract class LanguageThemeSelectorEvent extends Equatable {
  const LanguageThemeSelectorEvent();

  @override
  List<Object?> get props => [];
}

// Load saved language from secure storage
class LoadSavedLanguageEvent extends LanguageThemeSelectorEvent {}
class ChangeLanguageEvent extends LanguageThemeSelectorEvent {
  final Locale locale;

  const ChangeLanguageEvent(this.locale);

  @override
  List<Object?> get props => [locale];
}

//  Load saved theme from secure storage
class LoadSavedThemeEvent extends LanguageThemeSelectorEvent {}
class ChangeThemeEvent extends LanguageThemeSelectorEvent {
  final ThemeMode themeMode;

  const ChangeThemeEvent(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}