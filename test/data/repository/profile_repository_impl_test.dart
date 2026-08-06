import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:online_exam/core/constants/prefs_keys.dart';
import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/core/network/app_error.dart';
import 'package:online_exam/data/datasource/contract/profile_remote_datasource.dart';
import 'package:online_exam/data/mapper/user_mapper.dart';
import 'package:online_exam/data/models/auth/login_response.dart';
import 'package:online_exam/data/models/profile/change_password_request.dart';
import 'package:online_exam/data/models/profile/change_password_response.dart';
import 'package:online_exam/data/models/profile/edit_profile_request.dart';
import 'package:online_exam/data/models/profile/profile_response.dart';
import 'package:online_exam/data/repository/profile_repository_impl.dart';
import 'package:online_exam/domain/entities/user_entity.dart';
import 'package:online_exam/domain/repository/profile_repository.dart';

import 'profile_repository_impl_test.mocks.dart';

@GenerateMocks([ProfileRemoteDataSource, FlutterSecureStorage, UserMapper])
void main() {
  late MockProfileRemoteDataSource remoteDataSource;
  late MockFlutterSecureStorage secureStorage;
  late MockUserMapper userMapper;
  late ProfileRepository repository;

  final dummyUserEntity = UserEntity(
    id: '1',
    username: 'ali_ibrahim',
    firstName: 'Ali',
    lastName: 'Ibrahim',
    email: 'ali@example.com',
    phone: '01000000000',
  );

  final dummyAppError = ServerAppError("Server Error");

  setUpAll(() {
    remoteDataSource = MockProfileRemoteDataSource();
    secureStorage = MockFlutterSecureStorage();
    userMapper = MockUserMapper();

    getIt.registerFactory<ProfileRemoteDataSource>(() => remoteDataSource);
    getIt.registerFactory<FlutterSecureStorage>(() => secureStorage);
    getIt.registerFactory<UserMapper>(() => userMapper);

    getIt.registerFactory<ProfileRepository>(
      () => ProfileRepositoryImpl(getIt(), getIt(), getIt()),
    );

    repository = getIt<ProfileRepository>();
  });

  group("Test Get Profile Data Function", () {
    test(
      "getProfileData returns ApiSuccess with UserEntity when remote succeeds",
      () async {
        final response = ProfileResponse(user: UserModel());
        provideDummy<ApiResult<ProfileResponse>>(ApiSuccess(response));

        when(
          remoteDataSource.getProfileData(),
        ).thenAnswer((_) async => ApiSuccess(response));
        when(
          userMapper.mapUserModelToUserEntity(any),
        ).thenReturn(dummyUserEntity);

        final result = await repository.getProfileData();

        verify(remoteDataSource.getProfileData());
        verify(userMapper.mapUserModelToUserEntity(any));
        expect(result, isA<ApiSuccess<UserEntity>>());
        expect((result as ApiSuccess<UserEntity>).data, dummyUserEntity);
      },
    );

    test("getProfileData returns ApiFailure when remote fails", () async {
      provideDummy<ApiResult<ProfileResponse>>(ApiFailure(dummyAppError));

      when(
        remoteDataSource.getProfileData(),
      ).thenAnswer((_) async => ApiFailure(dummyAppError));

      final result = await repository.getProfileData();

      verify(remoteDataSource.getProfileData());
      verifyNever(userMapper.mapUserModelToUserEntity(any));
      expect(result, isA<ApiFailure<UserEntity>>());
    });
  });

  group("Test Edit Profile Function", () {
    final request = EditProfileRequest(
      username: 'ali_ibrahim',
      firstName: 'Ali',
      lastName: 'Ibrahim',
      email: 'ali@example.com',
      phone: '01000000000',
    );

    test("editProfile returns ApiSuccess with updated UserEntity", () async {
      final response = ProfileResponse(user: UserModel());
      provideDummy<ApiResult<ProfileResponse>>(ApiSuccess(response));

      when(
        remoteDataSource.editProfile(any),
      ).thenAnswer((_) async => ApiSuccess(response));
      when(
        userMapper.mapUserModelToUserEntity(any),
      ).thenReturn(dummyUserEntity);

      final result = await repository.editProfile(request);

      verify(remoteDataSource.editProfile(request));
      expect(result, isA<ApiSuccess<UserEntity>>());
    });

    test("editProfile returns ApiFailure on error", () async {
      provideDummy<ApiResult<ProfileResponse>>(ApiFailure(dummyAppError));

      when(
        remoteDataSource.editProfile(any),
      ).thenAnswer((_) async => ApiFailure(dummyAppError));

      final result = await repository.editProfile(request);

      expect(result, isA<ApiFailure<UserEntity>>());
    });
  });

  group("Test Change Password Function", () {
    final request = ChangePasswordRequest(
      oldPassword: 'oldPassword123',
      password: 'newPassword123',
      rePassword: 'newPassword123',
    );

    test(
      "changePassword succeeds and writes new token to secure storage when token exists",
      () async {
        final response = ChangePasswordResponse(token: "new_jwt_token");
        provideDummy<ApiResult<ChangePasswordResponse>>(ApiSuccess(response));

        when(
          remoteDataSource.changePassword(any),
        ).thenAnswer((_) async => ApiSuccess(response));

        final result = await repository.changePassword(request);

        verify(remoteDataSource.changePassword(request));
        verify(
          secureStorage.write(key: PrefsKeys.token, value: "new_jwt_token"),
        );
        expect(result, isA<ApiSuccess<void>>());
      },
    );

    test("changePassword returns ApiFailure on error", () async {
      provideDummy<ApiResult<ChangePasswordResponse>>(
        ApiFailure(dummyAppError),
      );

      when(
        remoteDataSource.changePassword(any),
      ).thenAnswer((_) async => ApiFailure(dummyAppError));

      final result = await repository.changePassword(request);

      expect(result, isA<ApiFailure<void>>());
      verifyNever(
        secureStorage.write(key: anyNamed('key'), value: anyNamed('value')),
      );
    });
  });
}
