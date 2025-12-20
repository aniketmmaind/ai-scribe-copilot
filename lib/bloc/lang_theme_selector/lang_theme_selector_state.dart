part of 'lang_selector_bloc.dart';

class LanguageThemeSelectorState extends Equatable {
  final Locale? locale;
  final ThemeMode? themeMode;

  const LanguageThemeSelectorState({
    required this.locale,
    required this.themeMode,
  });

  LanguageThemeSelectorState copyWith({Locale? locale, ThemeMode? themeMode}) {
    return LanguageThemeSelectorState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [locale, themeMode];
}
