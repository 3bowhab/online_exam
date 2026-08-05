import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/network/api_constants.dart';
import 'package:online_exam/core/network/base_response.dart';
import 'package:online_exam/data/models/auth/forgot_password_request.dart';
import 'package:online_exam/data/models/auth/login_request.dart';
import 'package:online_exam/data/models/auth/login_response.dart';
import 'package:online_exam/data/models/auth/logout_response.dart';
import 'package:online_exam/data/models/auth/reset_password_request.dart';
import 'package:online_exam/data/models/auth/verify_reset_code_request.dart';
import 'package:online_exam/data/models/profile/change_password_request.dart';
import 'package:online_exam/data/models/profile/change_password_response.dart';
import 'package:online_exam/data/models/profile/edit_profile_request.dart';
import 'package:online_exam/data/models/profile/profile_response.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@injectable
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(Dio dio) = _ApiClient;

  @POST(ApiConstants.forgotPassword)
  Future<BaseResponse<void>> forgotPassword(
    @Body() ForgotPasswordRequest request,
  );

  @POST(ApiConstants.verifyResetCode)
  Future<BaseResponse<void>> verifyResetCode(
    @Body() VerifyResetCodeRequest request,
  );

  @PUT(ApiConstants.resetPassword)
  Future<BaseResponse<void>> resetPassword(
    @Body() ResetPasswordRequest request,
  );

  @POST(ApiConstants.login)
  Future<LoginResponse> login(@Body() LoginRequest request);

  @GET(ApiConstants.logout)
  Future<LogoutResponse> logout();

  @GET(ApiConstants.profileData)
  Future<ProfileResponse> getProfileData();

  @PUT(ApiConstants.editProfile)
  Future<ProfileResponse> editProfile(
    @Body() EditProfileRequest request,
  );

  @PATCH(ApiConstants.changePassword)
  Future<ChangePasswordResponse> changePassword(
    @Body() ChangePasswordRequest request,
  );
}