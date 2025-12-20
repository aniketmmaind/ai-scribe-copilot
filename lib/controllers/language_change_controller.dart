import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeController with ChangeNotifier {
  Locale? _appLocale;
  ThemeMode? _themeMode = ThemeMode.system;

  Locale? get appLocale => _appLocale;
  ThemeMode? get themeMode => _themeMode;


  void changeLanguage(Locale type) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _appLocale = type;
    if (type == Locale('e')) {
      await sp.setString("language_code", 'en');
    } else {
      await sp.setString("language_code", 'hi');
    }
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', _themeToString(mode));

    notifyListeners(); // no restart needed
  }

  // Helpers
  String _themeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
}
