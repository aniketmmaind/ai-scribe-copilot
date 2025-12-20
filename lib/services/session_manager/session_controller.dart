import 'dart:convert';

import 'package:ai_scribe_copilot/services/storage/local_db.dart';
import 'package:flutter/material.dart';

import '../../models/user/user_model.dart';
import '../storage/local_storage.dart';

// create a single tone widget for handling user data auth and visitor token, usermodel, islogin
class SessionController {
  static final SessionController _session = SessionController._internal();
  final LocalStorage localStorage = LocalStorage();

  static bool? isLogin;
  static String? authToken;
  static String? refreshToken;
  static User? user;

  SessionController._internal() {
    isLogin = false;
    authToken = "";
    refreshToken = "";
    user = null;
  }

  factory SessionController() {
    return _session;
  }

  // ------------ LANGUAGE STORAGE ---------------
  Future<void> saveLanguageCode(String code) async {
    await localStorage.setValue("language_code", code);
  }

  Future<String> getLanguageCode() async {
    final code = await localStorage.getValue("language_code");
    return code ?? "en"; // default language
  }

  // ------------ Theme STORAGE ---------------
  Future<void> saveTheme(ThemeMode mode) async {
    await localStorage.setValue("mode", _themeToString(mode));
  }

  Future<ThemeMode> getTheme() async {
    final code = await localStorage.getValue("mode");
    if (code == null) {
      return ThemeMode.light;
    }
    return _stringToTheme(code); // default language
  }

  Future<void> saveAuthToken(String name, dynamic token) async {
    localStorage.setValue(name, token);
    SessionController.authToken = token;
  }

  Future<void> saveRefreshToken(String name, dynamic token) async {
    localStorage.setValue(name, token);
    SessionController.refreshToken = token;
  }

  Future<void> saveValue(String key, dynamic value) async {
    localStorage.setValue(key, value);
  }

  Future<dynamic> getValue(String name) async {
    return localStorage.getValue(name);
  }

  Future<bool> deleteValue(String name) async {
    return localStorage.deleteValue(name);
  }

  Future<void> setUserPreference(var user) async {
    await localStorage.setValue("user_model", user);
    localStorage.setValue('isLogin', 'true');
  }

  Future<void> getUserFromPreference() async {
    try {
      String userData = await localStorage.getValue('user_model');
      var isLogin = await localStorage.getValue('isLogin');

      // Restore auth token at revisit
      SessionController.authToken = await localStorage.getValue('auth_token');
      SessionController.refreshToken = await localStorage.getValue(
        'refresh_token',
      );
      if (userData.isNotEmpty) {
        SessionController.user = User.fromJson(jsonDecode(userData));
      }
      SessionController.isLogin = isLogin == 'true' ? true : false;
    } catch (e) {
      // debugPrint(e.toString());
    }
  }

  // to clear local storage data
  Future<bool> clearUserFromPreference() async {
    LocalDb.instance.delete('pending_chunks', "status = ?", ["pending"]);
    return await localStorage.clearAll();
  }

  // Convert theme mode to string
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

  // Convert string to theme mode
  ThemeMode _stringToTheme(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.light;
    }
  }
}
