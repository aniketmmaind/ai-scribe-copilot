import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  AppController() {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final theme = prefs.getString('themeMode') ?? 'system';
    final lang = prefs.getString('language') ?? 'en';

    _themeMode = _stringToThemeMode(theme);
    _locale = Locale(lang);

    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', _themeToString(mode));

    notifyListeners(); // no restart needed
  }

  void setLanguage(String langCode) async {
    _locale = Locale(langCode);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', langCode);

    notifyListeners(); // no restart needed
  }

  // Helpers
  String _themeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light: return 'light';
      case ThemeMode.dark: return 'dark';
      default: return 'system';
    }
  }

  ThemeMode _stringToThemeMode(String s) {
    switch (s) {
      case 'light': return ThemeMode.light;
      case 'dark': return ThemeMode.dark;
      default: return ThemeMode.system;
    }
  }
}
