import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/core/network/base_response.dart';

abstract class AuthRepository {
  Future<ApiResult<BaseResponse<void>>> forgotPassword(String email);
  Future<ApiResult<BaseResponse<void>>> verifyResetCode(String resetCode);
  Future<ApiResult<BaseResponse<void>>> resetPassword(
    String email,
    String newPassword,
  );
}
