import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:tuple/tuple.dart';

abstract class InsertAndUpdateBoundResource<ResultType> with TokenHandler {
  static const _STATUS = 'status';
  static const _PAYLOAD = 'payload';

  Future<Tuple2<int, ResultType>> executeInsert(
      String modelInJson, String url) async {
    try {
      final mIsValidToken = await isValidToken();
      if (mIsValidToken != 200) return Tuple2(mIsValidToken, null);

      final response = await _doRequest(url, modelInJson, true)
          .timeout(Duration(seconds: Constants.TIME_OUT_SECONDS));

      if (response.statusCode == 400) {
        final finalStatusCode = _alreadyExistAttributeCode(response.body);
        return Tuple2(finalStatusCode, null);
      }

      final decodedData = _decodeJson(response.body);

      final statusCode = decodedData.item1;

      if (!kIsWeb && statusCode == 201) doOperationInDb(decodedData.item2);

      return Tuple2(statusCode, decodedData.item2);
    } on SocketException catch (e) {
      return Tuple2(e.osError.errorCode, null);
    } on TimeoutException catch (_) {
      return Tuple2(Constants.TIME_OUT_EXCEPTION_CODE, null);
    } on http.ClientException catch (_) {
      return Tuple2(7, null);
    } catch (e) {
      return Tuple2(-1, null);
    }
  }

  Future<int> executeUpdate(
      dynamic modelInJson, ResultType model, String url) async {
    try {
      final mIsValidToken = await isValidToken();
      if (mIsValidToken != 200) return mIsValidToken;

      final response = await _doRequest(url, modelInJson, false)
          .timeout(Duration(seconds: Constants.TIME_OUT_SECONDS));

      final statusCode = response.statusCode;

      if (statusCode == 400) {
        final finalStatusCode = _alreadyExistAttributeCode(response.body);
        return finalStatusCode;
      }

      if (!kIsWeb && statusCode == 204) doOperationInDb(model);

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

  Future<http.Response> _doRequest(
      String url, String body, bool isInsert) async {
    return (isInsert)
        ? await http.post(url, headers: Constants.getHeaders(), body: body)
        : await http.put(url, headers: Constants.getHeaders(), body: body);
  }

  Tuple2<int, ResultType> _decodeJson(String responseBody) {
    final decodedData = json.decode(responseBody);

    return Tuple2(
        decodedData[_STATUS],
        (decodedData[_PAYLOAD] != null)
            ? buildNewModel(decodedData[_PAYLOAD])
            : null);
  }

  //Only for insert
  ResultType buildNewModel(dynamic payload);

  void doOperationInDb(ResultType model);

  bool _alreadyExistEmail(String body) =>
      body.contains('The attribute email already exists');

  bool _alreadyExistPhone(String body) =>
      body.contains('The attribute phone already exists');

  int _alreadyExistAttributeCode(String body) {
    if (_alreadyExistEmail(body)) {
      return Constants.EMAIL_ALREADY_IN_USE;
    }
    if (_alreadyExistPhone(body)) {
      return Constants.PHONE_ALREADY_IN_USE;
    }
    return 400;
  }
}
