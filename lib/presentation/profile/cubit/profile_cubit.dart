import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/base/cubit/base_cubit.dart';
import 'package:online_exam/core/base/cubit/base_state.dart';
import 'package:online_exam/core/base/cubit/state_status.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/domain/use_case/auth/logout_use_case.dart';
import 'package:online_exam/presentation/profile/cubit/profile_events.dart';
import 'package:online_exam/presentation/profile/cubit/profile_state.dart';

@injectable
class ProfileCubit extends BaseCubit<ProfileState> {
  final LogoutUseCase logoutUseCase;

  ProfileCubit(this.logoutUseCase) : super(const ProfileState());

  final StreamController<ProfileUiEvents> _uiController =
      StreamController<ProfileUiEvents>.broadcast();
  Stream<ProfileUiEvents> get uiStream => _uiController.stream;

  Future<void> doIntent(ProfileEvents event) async {
    switch (event) {
      case SubmitLogoutEvent():
        await _logout();
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
