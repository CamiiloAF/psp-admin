import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:tuple/tuple.dart';

abstract class NetworkBoundResource<ResultType> with TokenHandler {
  int _statusCode = 0;

  Future<Tuple2<int, ResultType>> execute(bool isRefreshing) async {
    final mIsValidToken = await isValidToken();
    if (mIsValidToken != 200) return Tuple2(mIsValidToken, null);

    ResultType dbValue;

    if (!kIsWeb) {
      dbValue = await loadFromLocalStorage();
    }

    ResultType dataFromNetwork;

    if (kIsWeb || isRefreshing || shouldFetch(dbValue)) {
      dataFromNetwork = await _fetchFromNetwork();
    }

    if (_statusCode == 0) return Tuple2(200, await loadFromLocalStorage());

    if (_statusCode == 200) {
      return (kIsWeb)
          ? Tuple2(_statusCode, dataFromNetwork)
          : Tuple2(_statusCode, await loadFromLocalStorage());
    } else if (!kIsWeb && _statusCode == 7) {
      return Tuple2((isRefreshing) ? 7 : 200, await loadFromLocalStorage());
    } else {
      return Tuple2(_statusCode, null);
    }
  }

  Future<ResultType> _fetchFromNetwork() async {
    try {
      final response = await createCall()
          .timeout(Duration(seconds: Constants.TIME_OUT_SECONDS));

      final Map<String, dynamic> decodedData = json.decode(response.body);
      _statusCode = decodedData['status'];

      final items = decodeData(decodedData['payload']);

      if (kIsWeb) {
        return items;
      } else if (_statusCode == 200 || _statusCode == 404) {
        await saveCallResult(items);
      }
    } on SocketException catch (e) {
      onFetchFailed();
      _statusCode = e.osError.errorCode;
    } on http.ClientException catch (_) {
      onFetchFailed();
      _statusCode = 7;
    } on TimeoutException catch (_) {
      onFetchFailed();
      _statusCode = Constants.TIME_OUT_EXCEPTION_CODE;
    } catch (e) {
      onFetchFailed();
      _statusCode = -1;
    }
    return null;
  }

  Future saveCallResult(ResultType item);
  bool shouldFetch(ResultType data);
  Future<ResultType> loadFromLocalStorage();
  Future<Response> createCall();
  void onFetchFailed();
  ResultType decodeData(List<dynamic> payload);
}
