import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/core/network/app_error.dart';
import 'package:online_exam/domain/entities/user_entity.dart';
import 'package:online_exam/domain/repository/profile_repository.dart';
import 'package:online_exam/domain/use_case/profile/get_profile_use_case.dart';

import 'get_profile_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepository])
void main() {
  late MockProfileRepository repository;
  late GetProfileUseCase getProfileUseCase;

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
    getIt.registerFactory<GetProfileUseCase>(() => GetProfileUseCase(getIt()));

    getProfileUseCase = getIt<GetProfileUseCase>();
  });

  group("Test GetProfileUseCase", () {
    test("GetProfileUseCase success state", () async {
      provideDummy<ApiResult<UserEntity>>(ApiSuccess(dummyUserEntity));
      when(
        repository.getProfileData(),
      ).thenAnswer((_) async => ApiSuccess(dummyUserEntity));

      var response = await getProfileUseCase.execute();

      verify(repository.getProfileData());
      expect(response, isA<ApiSuccess<UserEntity>>());
    });

    test("GetProfileUseCase failure state", () async {
      provideDummy<ApiResult<UserEntity>>(ApiFailure(dummyAppError));
      when(
        repository.getProfileData(),
      ).thenAnswer((_) async => ApiFailure(dummyAppError));

      var response = await getProfileUseCase.execute();

      verify(repository.getProfileData());
      expect(response, isA<ApiFailure<UserEntity>>());
    });
  });
}
