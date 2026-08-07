import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:online_exam/core/base/cubit/state_status.dart';
import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/core/network/app_error.dart';
import 'package:online_exam/data/models/profile/change_password_request.dart';
import 'package:online_exam/data/models/profile/edit_profile_request.dart';
import 'package:online_exam/domain/entities/user_entity.dart';
import 'package:online_exam/domain/use_case/auth/logout_use_case.dart';
import 'package:online_exam/domain/use_case/profile/change_password_use_case.dart';
import 'package:online_exam/domain/use_case/profile/edit_profile_use_case.dart';
import 'package:online_exam/domain/use_case/profile/get_profile_use_case.dart';
import 'package:online_exam/presentation/profile/cubit/profile_cubit.dart';
import 'package:online_exam/presentation/profile/cubit/profile_events.dart';

import 'profile_cubit_test.mocks.dart';

@GenerateMocks([
  GetProfileUseCase,
  EditProfileUseCase,
  ChangePasswordUseCase,
  LogoutUseCase,
])
void main() {
  late MockGetProfileUseCase getProfileUseCase;
  late MockEditProfileUseCase editProfileUseCase;
  late MockChangePasswordUseCase changePasswordUseCase;
  late MockLogoutUseCase logoutUseCase;
  late ProfileCubit profileCubit;

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
    getProfileUseCase = MockGetProfileUseCase();
    editProfileUseCase = MockEditProfileUseCase();
    changePasswordUseCase = MockChangePasswordUseCase();
    logoutUseCase = MockLogoutUseCase();

    getIt.registerFactory<GetProfileUseCase>(() => getProfileUseCase);
    getIt.registerFactory<EditProfileUseCase>(() => editProfileUseCase);
    getIt.registerFactory<ChangePasswordUseCase>(() => changePasswordUseCase);
    getIt.registerFactory<LogoutUseCase>(() => logoutUseCase);

    getIt.registerFactory<ProfileCubit>(
      () => ProfileCubit(getIt(), getIt(), getIt(), getIt()),
    );
  });

  group("Testing ProfileCubit - FetchProfileDataEvent", () {
    setUp(() {
      profileCubit = getIt<ProfileCubit>();
    });

    test("Fetch profile data success state", () async {
      expect(profileCubit.state.profileDataState.status, StateStatus.initial);

      provideDummy<ApiResult<UserEntity>>(ApiSuccess(dummyUserEntity));
      when(
        getProfileUseCase.execute(),
      ).thenAnswer((_) async => ApiSuccess(dummyUserEntity));

      await profileCubit.doIntent(FetchProfileDataEvent());

      expect(profileCubit.state.profileDataState.status, StateStatus.success);
      expect(profileCubit.state.profileDataState.data, dummyUserEntity);
    });

    test("Fetch profile data failure state", () async {
      expect(profileCubit.state.profileDataState.status, StateStatus.initial);

      provideDummy<ApiResult<UserEntity>>(ApiFailure(dummyAppError));
      when(
        getProfileUseCase.execute(),
      ).thenAnswer((_) async => ApiFailure(dummyAppError));

      await profileCubit.doIntent(FetchProfileDataEvent());

      expect(profileCubit.state.profileDataState.status, StateStatus.error);
      expect(
        profileCubit.state.profileDataState.message,
        dummyAppError.message,
      );
    });
  });

  group("Testing ProfileCubit - SubmitEditProfileEvent", () {
    setUp(() {
      profileCubit = getIt<ProfileCubit>();
    });

    final request = EditProfileRequest(
      username: 'ali_ibrahim',
      firstName: 'Ali',
      lastName: 'Ibrahim',
      email: 'ali@example.com',
      phone: '01000000000',
    );

    test("Edit profile success state", () async {
      expect(profileCubit.state.editProfileState.status, StateStatus.initial);

      provideDummy<ApiResult<UserEntity>>(ApiSuccess(dummyUserEntity));
      when(
        editProfileUseCase.execute(any),
      ).thenAnswer((_) async => ApiSuccess(dummyUserEntity));

      await profileCubit.doIntent(SubmitEditProfileEvent(request));

      expect(profileCubit.state.editProfileState.status, StateStatus.success);
      expect(profileCubit.state.profileDataState.status, StateStatus.success);
      expect(profileCubit.state.profileDataState.data, dummyUserEntity);
    });

    test("Edit profile failure state", () async {
      expect(profileCubit.state.editProfileState.status, StateStatus.initial);

      provideDummy<ApiResult<UserEntity>>(ApiFailure(dummyAppError));
      when(
        editProfileUseCase.execute(any),
      ).thenAnswer((_) async => ApiFailure(dummyAppError));

      await profileCubit.doIntent(SubmitEditProfileEvent(request));

      expect(profileCubit.state.editProfileState.status, StateStatus.error);
      expect(
        profileCubit.state.editProfileState.message,
        dummyAppError.message,
      );
    });
  });

  group("Testing ProfileCubit - SubmitChangePasswordEvent", () {
    setUp(() {
      profileCubit = getIt<ProfileCubit>();
    });

    final request = ChangePasswordRequest(
      oldPassword: 'oldPassword123',
      password: 'newPassword123',
      rePassword: 'newPassword123',
    );

    test("Change password success state", () async {
      expect(
        profileCubit.state.changePasswordState.status,
        StateStatus.initial,
      );

      provideDummy<ApiResult<void>>(const ApiSuccess(null));
      when(
        changePasswordUseCase.execute(any),
      ).thenAnswer((_) async => const ApiSuccess(null));

      await profileCubit.doIntent(SubmitChangePasswordEvent(request));

      expect(
        profileCubit.state.changePasswordState.status,
        StateStatus.success,
      );
    });

    test("Change password failure state", () async {
      expect(
        profileCubit.state.changePasswordState.status,
        StateStatus.initial,
      );

      provideDummy<ApiResult<void>>(ApiFailure(dummyAppError));
      when(
        changePasswordUseCase.execute(any),
      ).thenAnswer((_) async => ApiFailure(dummyAppError));

      await profileCubit.doIntent(SubmitChangePasswordEvent(request));

      expect(profileCubit.state.changePasswordState.status, StateStatus.error);
      expect(
        profileCubit.state.changePasswordState.message,
        dummyAppError.message,
      );
    });
  });

  group("Testing ProfileCubit - SubmitLogoutEvent", () {
    setUp(() {
      profileCubit = getIt<ProfileCubit>();
    });

    test("Logout success state", () async {
      expect(profileCubit.state.logoutState.status, StateStatus.initial);

      provideDummy<ApiResult<void>>(const ApiSuccess(null));
      when(
        logoutUseCase.execute(),
      ).thenAnswer((_) async => const ApiSuccess(null));

      await profileCubit.doIntent(SubmitLogoutEvent());

      expect(profileCubit.state.logoutState.status, StateStatus.success);
    });

    test("Logout failure state", () async {
      expect(profileCubit.state.logoutState.status, StateStatus.initial);

      provideDummy<ApiResult<void>>(ApiFailure(dummyAppError));
      when(
        logoutUseCase.execute(),
      ).thenAnswer((_) async => ApiFailure(dummyAppError));

      await profileCubit.doIntent(SubmitLogoutEvent());

      expect(profileCubit.state.logoutState.status, StateStatus.error);
      expect(profileCubit.state.logoutState.message, dummyAppError.message);
    });
  });
}
