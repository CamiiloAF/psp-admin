import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const String _PREF_TOKEN = 'token';
  static const String _PREF_TOKEN_SAVED_AT = 'tokenSavedAt';
  static const String _PREF_CURRENT_USER = 'currentUser';
  static const String _PREF_THEME = 'theme';

  static final Preferences _instancia = Preferences._internal();

  factory Preferences() {
    return _instancia;
  }

  Preferences._internal();

  SharedPreferences _prefs;

  void initPrefs() async => _prefs = await SharedPreferences.getInstance();

  // * Token
  String get token => _prefs.getString(_PREF_TOKEN) ?? '';
  set token(String value) => _prefs.setString(_PREF_TOKEN, value);

  int get tokenSavedAt => _prefs.getInt(_PREF_TOKEN_SAVED_AT);
  set tokenSavedAt(int value) => _prefs.setInt(_PREF_TOKEN_SAVED_AT, value);

  // * Current user
  String get curentUser => _prefs.getString(_PREF_CURRENT_USER) ?? '';
  set curentUser(String value) => _prefs.setString(_PREF_CURRENT_USER, value);

  // * Theme
  // 1 is light - 2 is dark
  int get theme => _prefs.getInt(_PREF_THEME) ?? 1;

  set theme(int value) => _prefs.setInt(_PREF_THEME, value);

  void clearPreferences() async => await _prefs.clear();
}
