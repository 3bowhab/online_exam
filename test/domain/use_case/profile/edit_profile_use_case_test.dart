import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/core/network/app_error.dart';
import 'package:online_exam/data/models/profile/edit_profile_request.dart';
import 'package:online_exam/domain/entities/user_entity.dart';
import 'package:online_exam/domain/repository/profile_repository.dart';
import 'package:online_exam/domain/use_case/profile/edit_profile_use_case.dart';

import 'edit_profile_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepository])
void main() {
  late MockProfileRepository repository;
  late EditProfileUseCase editProfileUseCase;

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
    repository = MockProfileRepository();

    getIt.registerFactory<ProfileRepository>(() => repository);
    getIt.registerFactory<EditProfileUseCase>(() => EditProfileUseCase(getIt()));

    editProfileUseCase = getIt<EditProfileUseCase>();
  });

  group("Test EditProfileUseCase", () {
    final request = EditProfileRequest(
      username: 'ali_ibrahim',
      firstName: 'Ali',
      lastName: 'Ibrahim',
      email: 'ali@example.com',
      phone: '01000000000',
    );

    test("EditProfileUseCase success state", () async {
      provideDummy<ApiResult<UserEntity>>(ApiSuccess(dummyUserEntity));
      when(repository.editProfile(any))
          .thenAnswer((_) async => ApiSuccess(dummyUserEntity));

      var response = await editProfileUseCase.execute(request);

      verify(repository.editProfile(request));
      expect(response, isA<ApiSuccess<UserEntity>>());
    });

    test("EditProfileUseCase failure state", () async {
      provideDummy<ApiResult<UserEntity>>(ApiFailure(dummyAppError));
      when(repository.editProfile(any))
          .thenAnswer((_) async => ApiFailure(dummyAppError));

      var response = await editProfileUseCase.execute(request);

      verify(repository.editProfile(request));
      expect(response, isA<ApiFailure<UserEntity>>());
    });
  });
}