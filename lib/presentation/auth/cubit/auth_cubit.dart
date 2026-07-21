import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:online_exam/core/base/cubit/base_cubit.dart';
import 'package:online_exam/core/base/cubit/base_state.dart';
import 'package:online_exam/core/base/cubit/state_status.dart';
import 'package:online_exam/core/network/api_result.dart';
import 'package:online_exam/domain/use_case/auth/forgot_password_use_case.dart';
import 'package:online_exam/domain/use_case/auth/reset_password_use_case.dart';
import 'package:online_exam/domain/use_case/auth/verify_reset_code_use_case.dart';
import 'package:online_exam/presentation/auth/cubit/auth_events.dart';
import 'package:online_exam/presentation/auth/cubit/auth_state.dart';

@injectable
class AuthCubit extends BaseCubit<AuthState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final VerifyResetCodeUseCase verifyResetCodeUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthCubit(
    this.forgotPasswordUseCase,
    this.verifyResetCodeUseCase,
    this.resetPasswordUseCase,
  ) : super(
        AuthState(
          forgotPasswordState: const BaseState(),
          verifyCodeState: const BaseState(),
          resetPasswordState: const BaseState(),
        ),
      );

  final StreamController<AuthUiEvents> _uiController =
      StreamController<AuthUiEvents>.broadcast();
  Stream<AuthUiEvents> get uiStream => _uiController.stream;

  Future<void> doIntent(AuthEvents event) async {
    switch (event) {
      case SubmitEmailEvent(:final email):
        await _forgotPassword(email);
      case SubmitVerifyCodeEvent(:final code):
        await _verifyResetCode(code);
      case SubmitResetPasswordEvent(:final email, :final newPassword):
        await _resetPassword(email, newPassword);
    }
  }

  Future<void> _forgotPassword(String email) async {
    emitSafe(
      state.copyWith(
        forgotPasswordState: const BaseState(status: StateStatus.loading),
      ),
    );
    final result = await forgotPasswordUseCase.execute(email);

    switch (result) {
      case ApiSuccess():
        emitSafe(
          state.copyWith(
            forgotPasswordState: const BaseState(status: StateStatus.success),
          ),
        );
        _uiController.add(NavigateToVerifyCodeScreen(email));
      case ApiFailure(:final error):
        emitSafe(
          state.copyWith(
            forgotPasswordState: BaseState(
              status: StateStatus.error,
              message: error.message,
            ),
          ),
        );
        _uiController.add(ShowErrorSnackBar(error.message));
    }
  }

  Future<void> _verifyResetCode(String code) async {
    emitSafe(
      state.copyWith(
        verifyCodeState: const BaseState(status: StateStatus.loading),
      ),
    );
    final result = await verifyResetCodeUseCase.execute(code);

    switch (result) {
      case ApiSuccess():
        emitSafe(
          state.copyWith(
            verifyCodeState: const BaseState(status: StateStatus.success),
          ),
        );
        _uiController.add(NavigateToResetPasswordScreen(''));
      case ApiFailure(:final error):
        emitSafe(
          state.copyWith(
            verifyCodeState: BaseState(
              status: StateStatus.error,
              message: error.message,
            ),
          ),
        );
        _uiController.add(ShowErrorSnackBar(error.message));
    }
  }

  Future<void> _resetPassword(String email, String newPassword) async {
    emitSafe(
      state.copyWith(
        resetPasswordState: const BaseState(status: StateStatus.loading),
      ),
    );
    final result = await resetPasswordUseCase.execute(email, newPassword);

    switch (result) {
      case ApiSuccess():
        emitSafe(
          state.copyWith(
            resetPasswordState: const BaseState(status: StateStatus.success),
          ),
        );
        _uiController.add(NavigateToLoginScreen());
      case ApiFailure(:final error):
        emitSafe(
          state.copyWith(
            resetPasswordState: BaseState(
              status: StateStatus.error,
              message: error.message,
            ),
          ),
        );
        _uiController.add(ShowErrorSnackBar(error.message));
    }
  }

  @override
  Future<void> close() {
    _uiController.close();
    return super.close();
  }
}
