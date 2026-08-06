import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/data/api/api_client.dart';
import 'package:online_exam/data/datasource/contract/profile_remote_datasource.dart';
import 'package:online_exam/data/datasource/implementation/profile_remote_datasource_impl.dart';
import 'package:online_exam/data/models/profile/change_password_request.dart';
import 'package:online_exam/data/models/profile/change_password_response.dart';
import 'package:online_exam/data/models/profile/edit_profile_request.dart';
import 'package:online_exam/data/models/profile/profile_response.dart';

import 'profile_remote_datasource_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late MockApiClient apiClient;
  late ProfileRemoteDataSource remoteDataSource;

  setUpAll(() {
    apiClient = MockApiClient();

    getIt.registerSingleton<ApiClient>(apiClient);
    getIt.registerFactory<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(getIt()),
    );

    remoteDataSource = getIt<ProfileRemoteDataSource>();
  });

  group("Test Get Profile Data Function", () {
    test(
      "Verify getProfileData called successfully and returns ApiSuccess",
      () async {
        when(
          apiClient.getProfileData(),
        ).thenAnswer((_) async => ProfileResponse());

        var response = await remoteDataSource.getProfileData();

        verify(apiClient.getProfileData());
        expect(response, isA<ApiSuccess<ProfileResponse>>());
      },
    );

    test(
      "Verify getProfileData returns ApiFailure when ApiClient throws exception",
      () async {
        when(
          apiClient.getProfileData(),
        ).thenThrow(TimeoutException("Connection Timeout"));

        var response = await remoteDataSource.getProfileData();

        verify(apiClient.getProfileData());
        expect(response, isA<ApiFailure<ProfileResponse>>());
      },
    );
  });

  group("Test Edit Profile Function", () {
    final request = EditProfileRequest(
      username: 'ali_ibrahim',
      firstName: 'Ali',
      lastName: 'Ibrahim',
      email: 'ali@example.com',
      phone: '01000000000',
    );

    test(
      "Verify editProfile called successfully and returns ApiSuccess",
      () async {
        when(
          apiClient.editProfile(any),
        ).thenAnswer((_) async => ProfileResponse());

        var response = await remoteDataSource.editProfile(request);

        verify(apiClient.editProfile(request));
        expect(response, isA<ApiSuccess<ProfileResponse>>());
      },
    );

    test("Verify editProfile returns ApiFailure on error", () async {
      when(apiClient.editProfile(any)).thenThrow(Exception("Network Error"));

      var response = await remoteDataSource.editProfile(request);

      expect(response, isA<ApiFailure<ProfileResponse>>());
    });
  });

  group("Test Change Password Function", () {
    final request = ChangePasswordRequest(
      oldPassword: 'oldPassword123',
      password: 'newPassword123',
      rePassword: 'newPassword123',
    );

    test(
      "Verify changePassword called successfully and returns ApiSuccess",
      () async {
        when(
          apiClient.changePassword(any),
        ).thenAnswer((_) async => ChangePasswordResponse());

        var response = await remoteDataSource.changePassword(request);

        verify(apiClient.changePassword(request));
        expect(response, isA<ApiSuccess<ChangePasswordResponse>>());
      },
    );

    test("Verify changePassword returns ApiFailure on error", () async {
      when(
        apiClient.changePassword(any),
      ).thenThrow(Exception("Invalid Credentials"));

      var response = await remoteDataSource.changePassword(request);

      expect(response, isA<ApiFailure<ChangePasswordResponse>>());
    });
  });
}
