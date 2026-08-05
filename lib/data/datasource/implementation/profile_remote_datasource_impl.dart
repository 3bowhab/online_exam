import 'package:injectable/injectable.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/core/network/safe_call.dart';
import 'package:online_exam/data/api/api_client.dart';
import 'package:online_exam/data/datasource/contract/profile_remote_datasource.dart';
import 'package:online_exam/data/models/profile/change_password_request.dart';
import 'package:online_exam/data/models/profile/change_password_response.dart';
import 'package:online_exam/data/models/profile/edit_profile_request.dart';
import 'package:online_exam/data/models/profile/profile_response.dart';

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<ApiResult<ProfileResponse>> getProfileData() {
    return safeCall(() => _apiClient.getProfileData());
  }

  @override
  Future<ApiResult<ProfileResponse>> editProfile(EditProfileRequest request) {
    return safeCall(() => _apiClient.editProfile(request));
  }

  @override
  Future<ApiResult<ChangePasswordResponse>> changePassword(
    ChangePasswordRequest request,
  ) {
    return safeCall(() => _apiClient.changePassword(request));
  }
}
