import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/constants/prefs_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class AuthInterceptor implements Interceptor {
  final SharedPreferences sharedPreferences;

  AuthInterceptor(this.sharedPreferences);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final token = sharedPreferences.getString(PrefsKeys.token);

    if (token != null && token.isNotEmpty) {
      options.headers[PrefsKeys.token] = token;
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }
}