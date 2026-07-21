import 'package:injectable/injectable.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/core/network/base_response.dart';
import 'package:online_exam/data/datasource/contract/auth_remote_datasource.dart';
import 'package:online_exam/data/models/auth/forgot_password_request.dart';
import 'package:online_exam/data/models/auth/reset_password_request.dart';
import 'package:online_exam/data/models/auth/verify_reset_code_request.dart';
import 'package:online_exam/domain/repository/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<BaseResponse<void>>> forgotPassword(String email) {
    return _remoteDataSource.forgotPassword(ForgotPasswordRequest(email: email));
  }

  @override
  Future<ApiResult<BaseResponse<void>>> verifyResetCode(String resetCode) {
    return _remoteDataSource.verifyResetCode(VerifyResetCodeRequest(resetCode: resetCode));
  }

  @override
  Future<ApiResult<BaseResponse<void>>> resetPassword(String email, String newPassword) {
    return _remoteDataSource.resetPassword(
      ResetPasswordRequest(email: email, newPassword: newPassword),
    );
  }
}