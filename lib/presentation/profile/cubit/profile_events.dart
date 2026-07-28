import 'package:flutter/foundation.dart';

@immutable
sealed class ProfileEvents {}

// User Actions (Intents)
class SubmitLogoutEvent extends ProfileEvents {}

// Single-time UI Events (Navigation & SnackBar)
sealed class ProfileUiEvents {}

class NavigateToLoginOnLogout extends ProfileUiEvents {}

class ShowProfileErrorSnackBar extends ProfileUiEvents {
  final String message;
  ShowProfileErrorSnackBar(this.message);
}
