import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/base/cubit/base_cubit.dart';
import 'package:online_exam/core/base/cubit/base_state.dart';
import 'package:online_exam/core/base/cubit/state_status.dart';
import 'package:online_exam/core/constants/app_strings.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/data/models/profile/change_password_request.dart';
import 'package:online_exam/data/models/profile/edit_profile_request.dart';
import 'package:online_exam/domain/use_case/auth/logout_use_case.dart';
import 'package:online_exam/domain/use_case/profile/change_password_use_case.dart';
import 'package:online_exam/domain/use_case/profile/edit_profile_use_case.dart';
import 'package:online_exam/domain/use_case/profile/get_profile_use_case.dart';
import 'package:online_exam/presentation/profile/cubit/profile_events.dart';
import 'package:online_exam/presentation/profile/cubit/profile_state.dart';

@injectable
class ProfileCubit extends BaseCubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final EditProfileUseCase editProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final LogoutUseCase logoutUseCase;

  ProfileCubit(
    this.getProfileUseCase,
    this.editProfileUseCase,
    this.changePasswordUseCase,
    this.logoutUseCase,
  ) : super(const ProfileState());

  final StreamController<ProfileUiEvents> _uiController =
      StreamController<ProfileUiEvents>.broadcast();
  Stream<ProfileUiEvents> get uiStream => _uiController.stream;

  Future<void> doIntent(ProfileEvents event) async {
    switch (event) {
      case FetchProfileDataEvent():
        await _fetchProfileData();
      case SubmitEditProfileEvent(:final request):
        await _editProfile(request);
      case SubmitChangePasswordEvent(:final request):
        await _changePassword(request);
      case SubmitLogoutEvent():
        await _logout();
    }
  }

  Future<void> _fetchProfileData() async {
    emitSafe(
      state.copyWith(
        profileDataState: const BaseState(status: StateStatus.loading),
      ),
    );

    final result = await getProfileUseCase.execute();

    switch (result) {
      case ApiSuccess(:final data):
        emitSafe(
          state.copyWith(
            profileDataState: BaseState(
              status: StateStatus.success,
              data: data,
            ),
          ),
        );
      case ApiFailure(:final error):
        emitSafe(
          state.copyWith(
            profileDataState: BaseState(
              status: StateStatus.error,
              message: error.message,
            ),
          ),
        );
        _uiController.add(ShowProfileErrorSnackBar(error.message));
    }
  }

  Future<void> _editProfile(EditProfileRequest request) async {
    emitSafe(
      state.copyWith(
        editProfileState: const BaseState(status: StateStatus.loading),
      ),
    );

    final result = await editProfileUseCase.execute(request);

    switch (result) {
      case ApiSuccess(:final data):
        emitSafe(
          state.copyWith(
            editProfileState: const BaseState(status: StateStatus.success),
            profileDataState: BaseState(
              status: StateStatus.success,
              data: data,
            ),
          ),
        );
        _uiController.add(
          ShowProfileSuccessSnackBar(AppStrings.profileUpdatedSuccessfully),
        );

      case ApiFailure(:final error):
        emitSafe(
          state.copyWith(
            editProfileState: BaseState(
              status: StateStatus.error,
              message: error.message,
            ),
          ),
        );
        _uiController.add(ShowProfileErrorSnackBar(error.message));
    }
  }

  Future<void> _changePassword(ChangePasswordRequest request) async {
    emitSafe(
      state.copyWith(
        changePasswordState: const BaseState(status: StateStatus.loading),
      ),
    );

    final result = await changePasswordUseCase.execute(request);

    switch (result) {
      case ApiSuccess():
        emitSafe(
          state.copyWith(
            changePasswordState: const BaseState(status: StateStatus.success),
          ),
        );
        _uiController.add(
          ShowProfileSuccessSnackBar(AppStrings.passwordChangedSuccessfully),
        );

      case ApiFailure(:final error):
        emitSafe(
          state.copyWith(
            changePasswordState: BaseState(
              status: StateStatus.error,
              message: error.message,
            ),
          ),
        );
        _uiController.add(ShowProfileErrorSnackBar(error.message));
    }
  }

  Future<void> _logout() async {
    emitSafe(
      state.copyWith(logoutState: const BaseState(status: StateStatus.loading)),
    );

    final result = await logoutUseCase.execute();

    switch (result) {
      case ApiSuccess():
        emitSafe(
          state.copyWith(
            logoutState: const BaseState(status: StateStatus.success),
          ),
        );
        _uiController.add(NavigateToLoginOnLogout());
      case ApiFailure(:final error):
        emitSafe(
          state.copyWith(
            logoutState: BaseState(
              status: StateStatus.error,
              message: error.message,
            ),
          ),
        );
        _uiController.add(ShowProfileErrorSnackBar(error.message));
    }
  }

  @override
  Future<void> close() {
    _uiController.close();
    return super.close();
  }
}
