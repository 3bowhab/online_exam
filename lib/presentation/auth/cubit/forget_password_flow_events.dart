import 'package:flutter/foundation.dart';

@immutable
sealed class ForgetPasswordFlowEvents {}

class SubmitEmailEvent extends ForgetPasswordFlowEvents {
  final String email;
  SubmitEmailEvent(this.email);
}

class SubmitVerifyCodeEvent extends ForgetPasswordFlowEvents {
  final String code;
  SubmitVerifyCodeEvent(this.code);
}

class SubmitResetPasswordEvent extends ForgetPasswordFlowEvents {
  final String email;
  final String newPassword;
  SubmitResetPasswordEvent({required this.email, required this.newPassword});
}

sealed class AuthUiEvents {}

class NavigateToVerifyCodeScreen extends AuthUiEvents {
  final String email;
  NavigateToVerifyCodeScreen(this.email);
}

class NavigateToResetPasswordScreen extends AuthUiEvents {
  final String email;
  NavigateToResetPasswordScreen(this.email);
}

class NavigateToLoginScreen extends AuthUiEvents {}

class ShowErrorSnackBar extends AuthUiEvents {
  final String message;
  ShowErrorSnackBar(this.message);
}
