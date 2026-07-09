import 'dart:async';
import 'package:dio/dio.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/core/network/app_error.dart';

Future<ApiResult<T>> safeCall<T>(Future<T> Function() apiCall) async {
  try {
    final response = await apiCall();
    return ApiSuccess(response);
  } catch (e) {
    return ApiFailure(errorParser(e));
  }
}

AppError errorParser(Object e) {
  if (e is DioException) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutAppError('Connection timeout, please try again.');
      case DioExceptionType.badResponse:
        final dynamic responseData = e.response?.data;
        if (responseData is Map<String, dynamic>) {
          final serverMessage =
              responseData['message'] ?? responseData['error'];
          if (serverMessage != null) {
            return ServerAppError(serverMessage.toString());
          }
        }
        return const ServerAppError('Bad response from server.');
      case DioExceptionType.cancel:
        return const ServerAppError('Request was cancelled.');
      case DioExceptionType.connectionError:
        return const NetworkAppError('No internet connection.');
      default:
        return const UnknownAppError('Something went wrong.');
    }
  }
  return const UnknownAppError('An unexpected error occurred.');
}
