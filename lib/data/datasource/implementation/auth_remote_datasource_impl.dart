import 'package:injectable/injectable.dart';
import 'package:online_exam/core/constants/prefs_keys.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/core/network/base_response.dart';
import 'package:online_exam/core/network/safe_call.dart';
import 'package:online_exam/data/api/api_client.dart';
import 'package:online_exam/data/datasource/contract/auth_remote_datasource.dart';
import 'package:online_exam/data/models/auth/forgot_password_request.dart';
import 'package:online_exam/data/models/auth/login_request.dart';
import 'package:online_exam/data/models/auth/login_response.dart';
import 'package:online_exam/data/models/auth/logout_response.dart';
import 'package:online_exam/data/models/auth/reset_password_request.dart';
import 'package:online_exam/data/models/auth/verify_reset_code_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  final SharedPreferences _prefs;

  AuthRemoteDataSourceImpl(this._apiClient, this._prefs);

  @override
  Future<ApiResult<BaseResponse<void>>> forgotPassword(
    ForgotPasswordRequest request,
  ) {
    return safeCall(() => _apiClient.forgotPassword(request));
  }

  @override
  Future<ApiResult<BaseResponse<void>>> verifyResetCode(
    VerifyResetCodeRequest request,
  ) {
    return safeCall(() => _apiClient.verifyResetCode(request));
  }

  @override
  Future<ApiResult<BaseResponse<void>>> resetPassword(
    ResetPasswordRequest request,
  ) {
    return safeCall(() => _apiClient.resetPassword(request));
  }

  @override
  Future<ApiResult<LoginResponse>> login(LoginRequest request) {
    return safeCall(() => _apiClient.login(request));
  }

  @override
  Future<ApiResult<LogoutResponse>> logout() async {
    final result = await safeCall(() => _apiClient.logout());

    if (result is ApiSuccess) {
      await _prefs.remove(PrefsKeys.token);
      await _prefs.remove(PrefsKeys.rememberMe);
      await _prefs.remove(PrefsKeys.savedEmail);
    }

    return result;
  }
}