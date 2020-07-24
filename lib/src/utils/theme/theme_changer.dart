import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier {
  bool _isDarkTheme = false;
  final Preferences preferences;

  ThemeData _currentTheme;

  bool get isDarkTheme => _isDarkTheme;

  ThemeData get currentTheme => _currentTheme;

  ThemeChanger(this.preferences) {
    switch (preferences.theme) {
      case 1:
        _isDarkTheme = false;
        _currentTheme = _lightThemeData();
        break;
      case 2:
        _isDarkTheme = true;
        _currentTheme = _darkThemeData();
        break;
      default:
        _isDarkTheme = false;
        _currentTheme = ThemeData.light();
    }
  }

  set isDarkTheme(bool value) {
    _isDarkTheme = value;

    if (value) {
      _currentTheme = _darkThemeData();
    } else {
      _currentTheme = _lightThemeData();
    }

    preferences.theme = (value) ? 2 : 1;
    notifyListeners();
  }

  ThemeData _darkThemeData() => ThemeData.dark().copyWith(
      accentColor: Color(0xffff7043),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Color(0xffff7043)),
      inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()));

  ThemeData _lightThemeData() => ThemeData.light().copyWith(
      accentColor: Color(0xffff7043),
      primaryColor: Color(0xFF607d8b),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Color(0xffff7043)),
      inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()));
}
