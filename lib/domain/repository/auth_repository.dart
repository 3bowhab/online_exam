import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/core/network/base_response.dart';
import 'package:online_exam/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<ApiResult<BaseResponse<void>>> forgotPassword(String email);
  Future<ApiResult<BaseResponse<void>>> verifyResetCode(String resetCode);
  Future<ApiResult<BaseResponse<void>>> resetPassword(
    String email,
    String newPassword,
  );
  Future<ApiResult<UserEntity>> login({
    required String email,
    required String password,
  });
  Future<ApiResult<void>> logout();
}
