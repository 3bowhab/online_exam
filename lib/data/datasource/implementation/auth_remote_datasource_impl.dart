import 'package:injectable/injectable.dart';
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

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

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
  Future<ApiResult<LogoutResponse>> logout() {
    return safeCall(() => _apiClient.logout());
  }
}
