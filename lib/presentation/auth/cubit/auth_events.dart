import 'package:flutter/foundation.dart';

@immutable
sealed class AuthEvents {}

// User Actions (Intents)
class SubmitEmailEvent extends AuthEvents {
  final String email;
  SubmitEmailEvent(this.email);
}

class SubmitVerifyCodeEvent extends AuthEvents {
  final String code;
  SubmitVerifyCodeEvent(this.code);
}

class SubmitResetPasswordEvent extends AuthEvents {
  final String email;
  final String newPassword;
  SubmitResetPasswordEvent({required this.email, required this.newPassword});
}

// Single-time UI Events (Navigation & Dialogs)
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
