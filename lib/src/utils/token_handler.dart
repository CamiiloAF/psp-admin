import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/constants.dart';

mixin TokenHandler {
  final preferences = Preferences();

//TODO: Cambiar esto por lo que David me digaE
  static const int _TOKEN_MAX_DAYS_ALIVE = 7;

  // * Returns 200 if it is ok, otherwise it is wrong
  Future<int> isValidToken() async {
    if (!existToken()) return 403;

    if (!_hasExpiredToken()) return 200;

    return await refreshToken();
  }

  Future<int> refreshToken() async {
    try {
      final url = '${Constants.baseUrl}/auth/new-token';

      final response = await http
          .post(url, headers: Constants.getHeaders())
          .timeout(Duration(seconds: Constants.TIME_OUT_SECONDS));

      final statusCode = response.statusCode;

      if (statusCode == 200) {
        final decodeResponse = json.decode(response.body);
        saveToken(decodeResponse['payload']);
      }

      return statusCode;
    } on SocketException catch (e) {
      return e.osError.errorCode;
    } on TimeoutException catch (_) {
      return Constants.TIME_OUT_EXCEPTION_CODE;
    } on http.ClientException catch (_) {
      return 7;
    } catch (e) {
      return -1;
    }
  }

  bool _hasExpiredToken() {
    final tokenSavedAt =
        DateTime.fromMillisecondsSinceEpoch(preferences.tokenSavedAt);

    final tokenDaysAlive = DateTime.now().difference(tokenSavedAt).inDays;
    return (tokenDaysAlive >= _TOKEN_MAX_DAYS_ALIVE);
  }

  @protected
  void saveToken(dynamic payload) {
    final String token = payload['auth_token'];

    Constants.token = token;
    preferences.token = token;
    preferences.tokenSavedAt = DateTime.now().millisecondsSinceEpoch;
  }

  static bool existToken() {
    final token = Preferences().token;
    return (token != null && token.isNotEmpty);
  }
}
