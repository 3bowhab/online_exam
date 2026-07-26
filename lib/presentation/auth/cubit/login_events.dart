import 'package:flutter/foundation.dart';
import 'package:online_exam/domain/entities/user_entity.dart';

@immutable
sealed class LoginEvents {}

class SubmitLoginEvent extends LoginEvents {
  final String email;
  final String password;
  final bool rememberMe;

  SubmitLoginEvent({
    required this.email,
    required this.password,
    required this.rememberMe,
  });
}

sealed class LoginUiEvents {}

class NavigateToHomeScreen extends LoginUiEvents {
  final UserEntity user;
  NavigateToHomeScreen(this.user);
}

class ShowLoginErrorSnackBar extends LoginUiEvents {
  final String message;
  ShowLoginErrorSnackBar(this.message);
}