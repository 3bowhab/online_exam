import 'package:online_exam/core/base/cubit/base_state.dart';

class AuthState {
  final BaseState<void> forgotPasswordState;
  final BaseState<void> verifyCodeState;
  final BaseState<void> resetPasswordState;

  AuthState({
    required this.forgotPasswordState,
    required this.verifyCodeState,
    required this.resetPasswordState,
  });

  AuthState copyWith({
    BaseState<void>? forgotPasswordState,
    BaseState<void>? verifyCodeState,
    BaseState<void>? resetPasswordState,
  }) {
    return AuthState(
      forgotPasswordState: forgotPasswordState ?? this.forgotPasswordState,
      verifyCodeState: verifyCodeState ?? this.verifyCodeState,
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,
    );
  }
}
