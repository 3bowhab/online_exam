import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/constants/prefs_keys.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/data/datasource/contract/profile_remote_datasource.dart';
import 'package:online_exam/data/mapper/user_mapper.dart';
import 'package:online_exam/data/models/profile/change_password_request.dart';
import 'package:online_exam/data/models/profile/edit_profile_request.dart';
import 'package:online_exam/domain/entities/user_entity.dart';
import 'package:online_exam/domain/repository/profile_repository.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final FlutterSecureStorage _secureStorage;
  final UserMapper _userMapper;

  ProfileRepositoryImpl(
    this._remoteDataSource,
    this._secureStorage,
    this._userMapper,
  );

  @override
  Future<ApiResult<UserEntity>> getProfileData() async {
    final result = await _remoteDataSource.getProfileData();

    switch (result) {
      case ApiSuccess(:final data):
        final userEntity = _userMapper.mapUserModelToUserEntity(data.user);
        return ApiSuccess(userEntity);

      case ApiFailure(:final error):
        return ApiFailure(error);
    }
  }

  @override
  Future<ApiResult<UserEntity>> editProfile(EditProfileRequest request) async {
    final result = await _remoteDataSource.editProfile(request);

    switch (result) {
      case ApiSuccess(:final data):
        final userEntity = _userMapper.mapUserModelToUserEntity(data.user);
        return ApiSuccess(userEntity);

      case ApiFailure(:final error):
        return ApiFailure(error);
    }
  }

  @override
  Future<ApiResult<void>> changePassword(ChangePasswordRequest request) async {
    final result = await _remoteDataSource.changePassword(request);

    switch (result) {
      case ApiSuccess(:final data):
        if (data.token != null && data.token!.isNotEmpty) {
          await _secureStorage.write(key: PrefsKeys.token, value: data.token!);
        }
        return const ApiSuccess(null);

      case ApiFailure(:final error):
        return ApiFailure(error);
    }
  }
}
