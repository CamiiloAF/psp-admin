import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';

class SessionProvider {
  final preferences = Preferences();

  Future<Map<String, dynamic>> doLogin(String email, String password) async {
    try {
      // final authData = {
      //   'identity' : email,
      //   'password' : password
      // };
      final url = '${Constants.baseUrl}/auth/login';

      final authData = {
        'identity': 'fernando.zapata.live@gmail.com',
        'password': '123456789'
      };

      final headers = {
        'http_csrf_token': Constants.httpCsrfToken,
      };

      final response = await http.post(url, headers: headers, body: authData);

      Map<String, dynamic> decodeResponse = json.decode(response.body);

      if (decodeResponse['status'] == 200) {
        _saveSharedPrefs(decodeResponse['payload']);
        return {'ok': true, 'status': decodeResponse['status']};
      } else {
        return {'ok': false, 'status': decodeResponse['status']};
      }
    } on SocketException catch (e) {
      return {'ok': false, 'status': e.osError.errorCode};
    } on http.ClientException catch (_) {
      return {'ok': false, 'status': 7};
    } catch (e) {
      return {'ok': false, 'status': -1};
    }
  }

  void _saveSharedPrefs(decodeResponse) {
    final token = decodeResponse['auth_token'];

    Constants.token = token;

    preferences.token = token;
    preferences.curentUser = json.encode(decodeResponse);
  }
}
