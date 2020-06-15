import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  bool _isDarkTheme = false;

  ThemeData _currentTheme;

  bool get isDarkTheme => _isDarkTheme;
  ThemeData get currentTheme => _currentTheme;

  ThemeChanger(int theme) {
    switch (theme) {
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
