import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/base/cubit/base_cubit.dart';
import 'package:online_exam/core/base/cubit/base_state.dart';
import 'package:online_exam/core/base/cubit/state_status.dart';
import 'package:online_exam/presentation/auth/cubit/login_events.dart';
import 'package:online_exam/presentation/auth/cubit/login_state.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/domain/use_case/auth/login_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class LoginCubit extends BaseCubit<LoginState> {
  final LoginUseCase loginUseCase;
  final SharedPreferences prefs;
  static const String _rememberMeKey = 'remember_me';
  static const String _savedEmailKey = 'saved_email';

  LoginCubit(this.loginUseCase, this.prefs) : super(const LoginState());

  final StreamController<LoginUiEvents> _uiController =
      StreamController<LoginUiEvents>.broadcast();
  Stream<LoginUiEvents> get uiStream => _uiController.stream;

  Future<void> doIntent(LoginEvents event) async {
    switch (event) {
      case SubmitLoginEvent(:final email, :final password, :final rememberMe):
        await _login(email, password, rememberMe);
    }
  }

  String? getSavedEmail() {
    final isRemembered = prefs.getBool(_rememberMeKey) ?? false;
    if (isRemembered) {
      return prefs.getString(_savedEmailKey);
    }
    return null;
  }

  Future<void> _login(String email, String password, bool rememberMe) async {
    emitSafe(
      state.copyWith(loginState: const BaseState(status: StateStatus.loading)),
    );

    final result = await loginUseCase.execute(email: email, password: password);

    switch (result) {
      case ApiSuccess(:final data):
        if (rememberMe) {
          await prefs.setBool(_rememberMeKey, true);
          await prefs.setString(_savedEmailKey, email);
        } else {
          await prefs.remove(_rememberMeKey);
          await prefs.remove(_savedEmailKey);
        }

        emitSafe(
          state.copyWith(
            loginState: BaseState(status: StateStatus.success, data: data),
          ),
        );
        _uiController.add(NavigateToHomeScreen(data));

      case ApiFailure(:final error):
        emitSafe(
          state.copyWith(
            loginState: BaseState(
              status: StateStatus.error,
              message: error.message,
            ),
          ),
        );
        _uiController.add(ShowLoginErrorSnackBar(error.message));
    }
  }

  @override
  Future<void> close() {
    _uiController.close();
    return super.close();
  }
}