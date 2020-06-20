import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const String _PREF_TOKEN = 'token';
  static const String _PREF_CURRENT_USER = 'currentUser';
  static const String _PREF_THEME = 'theme';

  static final Preferences _instancia = Preferences._internal();

  factory Preferences() {
    return _instancia;
  }

  Preferences._internal();

  SharedPreferences _prefs;

  void initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // GET y SET de token
  String get token {
    return _prefs.getString(_PREF_TOKEN) ?? '';
  }

  set token(String value) {
    _prefs.setString(_PREF_TOKEN, value);
  }

  void clearPreferences() async {
    await _prefs.clear();
  }

  // GET y SET current user
  String get curentUser {
    return _prefs.getString(_PREF_CURRENT_USER) ?? '';
  }

  set curentUser(String value) {
    _prefs.setString(_PREF_CURRENT_USER, value);
  }

  // GET y SET theme
  // 1 is light - 2 is dark
  int get theme {
    return _prefs.getInt(_PREF_THEME) ?? 1;
  }

  set theme(int value) {
    _prefs.setInt(_PREF_THEME, value);
  }
}
