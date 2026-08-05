import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/data/models/profile/change_password_request.dart';
import 'package:online_exam/data/models/profile/edit_profile_request.dart';
import 'package:online_exam/domain/entities/user_entity.dart';

abstract interface class ProfileRepository {
  Future<ApiResult<UserEntity>> getProfileData();
  Future<ApiResult<UserEntity>> editProfile(EditProfileRequest request);
  Future<ApiResult<void>> changePassword(ChangePasswordRequest request);
}
