import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/core/network/app_error.dart';
import 'package:online_exam/data/models/profile/change_password_request.dart';
import 'package:online_exam/domain/repository/profile_repository.dart';
import 'package:online_exam/domain/use_case/profile/change_password_use_case.dart';

import 'change_password_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepository])
void main() {
  late MockProfileRepository repository;
  late ChangePasswordUseCase changePasswordUseCase;

  final dummyAppError = ServerAppError("Server Error");

  setUpAll(() {
    repository = MockProfileRepository();

    getIt.registerFactory<ProfileRepository>(() => repository);
    getIt.registerFactory<ChangePasswordUseCase>(() => ChangePasswordUseCase(getIt()));

    changePasswordUseCase = getIt<ChangePasswordUseCase>();
  });

  group("Test ChangePasswordUseCase", () {
    final request = ChangePasswordRequest(
      oldPassword: 'oldPassword123',
      password: 'newPassword123',
      rePassword: 'newPassword123',
    );

    test("ChangePasswordUseCase success state", () async {
      provideDummy<ApiResult<void>>(const ApiSuccess(null));
      when(repository.changePassword(any))
          .thenAnswer((_) async => const ApiSuccess(null));

      var response = await changePasswordUseCase.execute(request);

      verify(repository.changePassword(request));
      expect(response, isA<ApiSuccess<void>>());
    });

    test("ChangePasswordUseCase failure state", () async {
      provideDummy<ApiResult<void>>(ApiFailure(dummyAppError));
      when(repository.changePassword(any))
          .thenAnswer((_) async => ApiFailure(dummyAppError));

      var response = await changePasswordUseCase.execute(request);

      verify(repository.changePassword(request));
      expect(response, isA<ApiFailure<void>>());
    });
  });
}