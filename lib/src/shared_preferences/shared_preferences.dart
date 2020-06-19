import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const String _PREF_TOKEN = 'token';
  static const String _PREF_CURRENT_USER = 'currentUser';

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

  void removeToken() {
    _prefs.remove(_PREF_TOKEN);
  }

  // GET y SET current user
  String get curentUser {
    return _prefs.getString(_PREF_CURRENT_USER) ?? '';
  }

  set curentUser(String value) {
    _prefs.setString(_PREF_CURRENT_USER, value);
  }
}
