import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/core/network/base_response.dart';
import 'package:online_exam/data/models/auth/forgot_password_request.dart';
import 'package:online_exam/data/models/auth/reset_password_request.dart';
import 'package:online_exam/data/models/auth/verify_reset_code_request.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResult<BaseResponse<void>>> forgotPassword(ForgotPasswordRequest request);
  Future<ApiResult<BaseResponse<void>>> verifyResetCode(VerifyResetCodeRequest request);
  Future<ApiResult<BaseResponse<void>>> resetPassword(ResetPasswordRequest request);
}