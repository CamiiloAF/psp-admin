import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:psp_admin/src/providers/db_provider.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/utils/rate_limiter.dart';

class SessionRepository with TokenHandler {
  Future<Map<String, dynamic>> doLogin(String email, String password) async {
    try {
      //TODO Descomentar esto en producción
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

      final response = await http
          .post(url, headers: headers, body: authData)
          .timeout(Duration(seconds: Constants.TIME_OUT_SECONDS));

      Map<String, dynamic> decodeResponse = json.decode(response.body);

      if (decodeResponse['status'] == 200) {
        await _saveSharedPrefs(decodeResponse['payload']);
        return {'ok': true, 'status': decodeResponse['status']};
      } else {
        return {'ok': false, 'status': decodeResponse['status']};
      }
    } on SocketException catch (e) {
      return {'ok': false, 'status': e.osError.errorCode};
    } on http.ClientException catch (_) {
      return {'ok': false, 'status': 7};
    } on TimeoutException catch (_) {
      return {'ok': false, 'status': Constants.TIME_OUT_EXCEPTION_CODE};
    } catch (e) {
      return {'ok': false, 'status': -1};
    }
  }

  Future<int> restorePasswordByEmail(String email) async {
    final url = '${Constants.baseUrl}/forgot-password/email';
    final body = {'email': email};

    return await _requestRestorePassword(url, body);
  }

  Future<int> restorePasswordByPhone(String phone) async {
    final url = '${Constants.baseUrl}/forgot-password/phone';
    final body = {'phone': phone};

    return await _requestRestorePassword(url, body);
  }

  Future<int> _requestRestorePassword(
      String url, Map<String, String> body) async {
    try {
      final headers = {
        'http_csrf_token': Constants.httpCsrfToken,
      };

      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(Duration(seconds: Constants.TIME_OUT_SECONDS));

      return response.statusCode;
    } on SocketException catch (e) {
      return e.osError.errorCode;
    } on http.ClientException catch (_) {
      return 7;
    } on TimeoutException catch (_) {
      return Constants.TIME_OUT_EXCEPTION_CODE;
    } catch (e) {
      return -1;
    }
  }

  Future<void> logOut() async {
    try {
      final url = '${Constants.baseUrl}/auth/logout';

      await http
          .post(url, headers: Constants.getHeaders())
          .timeout(Duration(seconds: Constants.TIME_OUT_SECONDS));

      await _clearLocalStorage();

      return;
    } catch (e) {
      return;
    }
  }

  void _saveSharedPrefs(dynamic payload) async {
    saveToken(payload);
    preferences.currentUser = await json.encode(payload);
  }

  void _clearLocalStorage() async {
    await DBProvider.db.deleteDb();
    await Preferences().clearPreferences();
    RateLimiter().clear();
  }
}
