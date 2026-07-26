import 'package:injectable/injectable.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/core/network/base_response.dart';
import 'package:online_exam/data/datasource/contract/auth_remote_datasource.dart';
import 'package:online_exam/data/mapper/user_mapper.dart';
import 'package:online_exam/data/models/auth/forgot_password_request.dart';
import 'package:online_exam/data/models/auth/login_request.dart';
import 'package:online_exam/data/models/auth/reset_password_request.dart';
import 'package:online_exam/data/models/auth/verify_reset_code_request.dart';
import 'package:online_exam/domain/entities/user_entity.dart';
import 'package:online_exam/domain/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SharedPreferences _prefs;

  AuthRepositoryImpl(this._remoteDataSource, this._prefs);

  @override
  Future<ApiResult<BaseResponse<void>>> forgotPassword(String email) {
    return _remoteDataSource.forgotPassword(
      ForgotPasswordRequest(email: email),
    );
  }

  @override
  Future<ApiResult<BaseResponse<void>>> verifyResetCode(String resetCode) {
    return _remoteDataSource.verifyResetCode(
      VerifyResetCodeRequest(resetCode: resetCode),
    );
  }

  @override
  Future<ApiResult<BaseResponse<void>>> resetPassword(
    String email,
    String newPassword,
  ) {
    return _remoteDataSource.resetPassword(
      ResetPasswordRequest(email: email, newPassword: newPassword),
    );
  }

  @override
  Future<ApiResult<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.login(
      LoginRequest(email: email, password: password),
    );

    switch (result) {
      case ApiSuccess(:final data):
        if (data.token != null && data.token!.isNotEmpty) {
          await _prefs.setString('token', data.token!);
        }

        final userEntity = data.user.toEntity();
        return ApiSuccess(userEntity);

      case ApiFailure(:final error):
        return ApiFailure(error);
    }
  }

  @override
  Future<ApiResult<void>> logout() async {
    final result = await _remoteDataSource.logout();

    switch (result) {
      case ApiSuccess():
        return const ApiSuccess(null);
      case ApiFailure(:final error):
        return ApiFailure(error);
    }
  }
}
