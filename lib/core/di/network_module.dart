import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/network/api_constants.dart';
import 'package:online_exam/core/network/auth_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class NetworkModule {
  @singleton
  Dio provideDio(AuthInterceptor authInterceptor) {
    final dio = Dio(_createBaseOptions());
    dio.interceptors.add(authInterceptor);

    if (kDebugMode) {
      dio.interceptors.add(_createLoggerInterceptor());
    }
    return dio;
  }

  BaseOptions _createBaseOptions() {
    return BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
    );
  }

  PrettyDioLogger _createLoggerInterceptor() {
    return PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    );
  }
}