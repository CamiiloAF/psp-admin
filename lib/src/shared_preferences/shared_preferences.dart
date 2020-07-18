import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const String _PREF_TOKEN = 'token';
  static const String _PREF_TOKEN_SAVED_AT = 'tokenSavedAt';
  static const String _PREF_CURRENT_USER = 'currentUser';

  static const String _PREF_lOGIN_ATTEMPS = 'loginTries';
  static const String _PREF_lOGIN_LAST_ATTEMP_AT = 'loginlastTryAt';

  static const String _PREF_THEME = 'theme';
  static const String _PREF_LANGUAGE_CODE = 'languageCode';

  static final Preferences _instance = Preferences._internal();

  factory Preferences() => _instance;

  Preferences._internal();

  SharedPreferences _prefs;

  void initPrefs() async => _prefs = await SharedPreferences.getInstance();

  // * Token
  String get token => _prefs.getString(_PREF_TOKEN) ?? '';
  set token(String value) => _prefs.setString(_PREF_TOKEN, value);

  int get tokenSavedAt => _prefs.getInt(_PREF_TOKEN_SAVED_AT);
  set tokenSavedAt(int value) => _prefs.setInt(_PREF_TOKEN_SAVED_AT, value);

  // * Current user
  String get currentUser => _prefs.getString(_PREF_CURRENT_USER) ?? '';
  set currentUser(String value) => _prefs.setString(_PREF_CURRENT_USER, value);

  // * Theme
  // 1 is light - 2 is dark
  int get theme => _prefs.getInt(_PREF_THEME) ?? 1;
  set theme(int value) => _prefs.setInt(_PREF_THEME, value);

  // * Login tries
  int get loginAttemps => _prefs.getInt(_PREF_lOGIN_ATTEMPS) ?? 0;
  set loginAttemps(int value) => _prefs.setInt(_PREF_lOGIN_ATTEMPS, value);

  int get loginLastAttempAt => _prefs.getInt(_PREF_lOGIN_LAST_ATTEMP_AT);
  set loginLastAttempAt(int value) =>
      _prefs.setInt(_PREF_lOGIN_LAST_ATTEMP_AT, value);

  void restoreLoginAttemps() {
    _prefs.remove(_PREF_lOGIN_ATTEMPS);
    _prefs.remove(_PREF_lOGIN_LAST_ATTEMP_AT);
  }

  // * App Language
  String get languageCode => _prefs.getString(_PREF_LANGUAGE_CODE) ?? '';
  set languageCode(String value) =>
      _prefs.setString(_PREF_LANGUAGE_CODE, value);

  void clearPreferences() async => await _prefs.clear();
}
