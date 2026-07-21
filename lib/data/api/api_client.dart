import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/network/api_constants.dart';
import 'package:online_exam/core/network/base_response.dart';
import 'package:online_exam/data/models/auth/forgot_password_request.dart';
import 'package:online_exam/data/models/auth/reset_password_request.dart';
import 'package:online_exam/data/models/auth/verify_reset_code_request.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@LazySingleton()
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(Dio dio) = _ApiClient;

  @POST('api/v1/auth/forgotPasswords')
  Future<BaseResponse<void>> forgotPassword(
    @Body() ForgotPasswordRequest request,
  );

  @POST('api/v1/auth/verifyResetCode')
  Future<BaseResponse<void>> verifyResetCode(
    @Body() VerifyResetCodeRequest request,
  );

  @PUT('api/v1/auth/resetPassword')
  Future<BaseResponse<void>> resetPassword(
    @Body() ResetPasswordRequest request,
  );
}
