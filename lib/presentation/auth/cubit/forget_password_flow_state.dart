import 'package:online_exam/core/base/cubit/base_state.dart';

class ForgetPasswordFlowState {
  final BaseState<void> forgotPasswordState;
  final BaseState<void> verifyCodeState;
  final BaseState<void> resetPasswordState;

  ForgetPasswordFlowState({
    required this.forgotPasswordState,
    required this.verifyCodeState,
    required this.resetPasswordState,
  });

  ForgetPasswordFlowState copyWith({
    BaseState<void>? forgotPasswordState,
    BaseState<void>? verifyCodeState,
    BaseState<void>? resetPasswordState,
  }) {
    return ForgetPasswordFlowState(
      forgotPasswordState: forgotPasswordState ?? this.forgotPasswordState,
      verifyCodeState: verifyCodeState ?? this.verifyCodeState,
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,
    );
  }
}
