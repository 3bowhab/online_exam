import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/data/models/profile/change_password_request.dart';
import 'package:online_exam/data/models/profile/change_password_response.dart';
import 'package:online_exam/data/models/profile/edit_profile_request.dart';
import 'package:online_exam/data/models/profile/profile_response.dart';

abstract class ProfileRemoteDataSource {
  Future<ApiResult<ProfileResponse>> getProfileData();
  Future<ApiResult<ProfileResponse>> editProfile(EditProfileRequest request);
  Future<ApiResult<ChangePasswordResponse>> changePassword(
    ChangePasswordRequest request,
  );
}
