import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../utils/constants.dart';
import '../local/cache_consumer.dart';
import '../local/storage_keys.dart';

const String _baseURL = "https://agar-online.com/api/";
const String _contentType = "Content-Type";
const String _authorization = "Authorization";
const String _accept = "accept";
const String _applicationJson = "application/json";
const String _lang = "lng";

class ApiConsumer {
  final Dio _dio;
  final CacheConsumer _cacheConsumer;
  final Interceptor _prettyDioLogger;

  ApiConsumer(this._dio, this._cacheConsumer, this._prettyDioLogger) {
    final BaseOptions baseOptions = BaseOptions(
      baseUrl: _baseURL,
      receiveDataWhenStatusError: true,
      connectTimeout: Constants.connectTimeout,
      receiveTimeout: Constants.connectTimeout,
      sendTimeout: Constants.connectTimeout,
      headers: {
        _contentType: _applicationJson,
        _accept: _applicationJson,
        _lang: "en",
      },
    );

    _dio.options = baseOptions;

    if (kDebugMode) {
      _dio.interceptors.add(_prettyDioLogger);
    }
  }

  Future<Response> get({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    final String? token = await _cacheConsumer.getSecuredData(StorageKeys.token);
    return await _dio.get(
      url,
      queryParameters: queryParameters,
      options: Options(
        headers: {
          _authorization: token != null ? "Bearer $token" : Constants.empty,
        },
      ),
    );
  }

  Future<Response> post({
    required String url,
    required var requestBody,
    Map<String, dynamic>? queryParameters,
  }) async {
    final String? token = await _cacheConsumer.getSecuredData(StorageKeys.token);
    return await _dio.post(
      url,
      queryParameters: queryParameters,
      data: requestBody,
      options: Options(
        headers: {
          _authorization: token != null ? "Bearer $token" : Constants.empty,
        },
      ),
    );
  }

  Future<Response> update({
    required String url,
    required var requestBody,
    Map<String, dynamic>? queryParameters,
  }) async {
    final String? token = await _cacheConsumer.getSecuredData(StorageKeys.token);
    return await _dio.put(
      url,
      queryParameters: queryParameters,
      data: requestBody,
      options: Options(
        headers: {
          _authorization: token != null ? "Bearer $token" : Constants.empty,
        },
      ),
    );
  }

  Future<Response> delete({
    required String url,
    var requestBody,
    Map<String, dynamic>? queryParameters,
  }) async {
    final String? token = await _cacheConsumer.getSecuredData(StorageKeys.token);
    return await _dio.delete(
      url,
      queryParameters: queryParameters,
      data: requestBody,
      options: Options(
        headers: {
          _authorization: token != null ? "Bearer $token" : Constants.empty,
        },
      ),
    );
  }
}
