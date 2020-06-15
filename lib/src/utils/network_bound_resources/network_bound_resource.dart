import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

abstract class NetworkBoundResource<ResultType> {
  int _statusCode = 0;

  Future<Tuple2<int, ResultType>> execute(bool isRefresing) async {
    ResultType dbValue;

    if (!kIsWeb) {
      dbValue = await loadFromDb();
    }

    ResultType dataFromNetwork;

    if (kIsWeb || isRefresing || shouldFetch(dbValue)) {
      dataFromNetwork = await _fetchFromNetwork();
    }

    if (_statusCode == 0) return Tuple2(200, await loadFromDb());

    if (_statusCode == 200) {
      return (kIsWeb)
          ? Tuple2(_statusCode, dataFromNetwork)
          : Tuple2(_statusCode, await loadFromDb());
    } else if (!kIsWeb && _statusCode == 7) {
      return Tuple2((isRefresing) ? 7 : 200, await loadFromDb());
    } else {
      return Tuple2(_statusCode, null);
    }
  }

  Future<ResultType> _fetchFromNetwork() async {
    try {
      final response = await createCall();

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
    } catch (e) {
      onFetchFailed();
      _statusCode = -1;
    }
    return null;
  }

  Future saveCallResult(ResultType item);
  bool shouldFetch(ResultType data);
  Future<ResultType> loadFromDb();
  Future<Response> createCall();
  void onFetchFailed();
  ResultType decodeData(List<dynamic> payload);
}
