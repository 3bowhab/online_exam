import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/network/api_constants.dart';
import 'package:online_exam/core/network/base_response.dart';
import 'package:online_exam/data/models/auth/forgot_password_request.dart';
import 'package:online_exam/data/models/auth/login_request.dart';
import 'package:online_exam/data/models/auth/login_response.dart';
import 'package:online_exam/data/models/profile/change_password_request.dart';
import 'package:online_exam/data/models/profile/change_password_response.dart';
import 'package:online_exam/data/models/profile/edit_profile_request.dart';
import 'package:online_exam/data/models/auth/logout_response.dart';
import 'package:online_exam/data/models/auth/reset_password_request.dart';
import 'package:online_exam/data/models/auth/verify_reset_code_request.dart';
import 'package:online_exam/data/models/profile/profile_response.dart';
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

  @POST('api/v1/auth/signin')
  Future<LoginResponse> login(@Body() LoginRequest request);

  @GET('api/v1/auth/logout')
  Future<LogoutResponse> logout(@Header('token') String token);

  @GET('api/v1/auth/profileData')
  Future<ProfileResponse> getProfileData(@Header('token') String token);

  @PUT('api/v1/auth/editProfile')
  Future<ProfileResponse> editProfile(
    @Header('token') String token,
    @Body() EditProfileRequest request,
  );

  @PATCH('api/v1/auth/changePassword')
  Future<ChangePasswordResponse> changePassword(
    @Header('token') String token,
    @Body() ChangePasswordRequest request,
  );
}
