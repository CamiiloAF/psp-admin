import 'package:flutter/material.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';

class SystemLanguageModel with ChangeNotifier {
  Locale _locale;
  final preferences = Preferences();

  SystemLanguageModel(String languageCode) {
    _locale = (languageCode != null && languageCode.isNotEmpty)
        ? Locale(languageCode)
        : null;
  }

  Locale get locale => _locale;

  set locale(Locale value) {
    _locale = value;
    preferences.languageCode = locale?.languageCode ?? '';
    notifyListeners();
  }
}
