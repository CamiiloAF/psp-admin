import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

abstract class NetworkBoundResource<ResultType> {
  int _statusCode = 0;

  Future<Tuple2<int, ResultType>> execute() async {
    ResultType dbValue;

    if (!kIsWeb) {
      dbValue = await loadFromDb();
    }

    ResultType dataFromNetwork;

    if (kIsWeb || shouldFetch(dbValue)) {
      dataFromNetwork = await _fetchFromNetwork();
    }

    if (_statusCode == 200) {
      if (kIsWeb) {
        return Tuple2(_statusCode, dataFromNetwork);
      } else {
        return Tuple2(_statusCode, await loadFromDb());
      }
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
