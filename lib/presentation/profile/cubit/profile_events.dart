import 'package:flutter/foundation.dart';
import 'package:online_exam/data/models/profile/change_password_request.dart';
import 'package:online_exam/data/models/profile/edit_profile_request.dart';

@immutable
sealed class ProfileEvents {}

class FetchProfileDataEvent extends ProfileEvents {}

class SubmitEditProfileEvent extends ProfileEvents {
  final EditProfileRequest request;
  SubmitEditProfileEvent(this.request);
}

class SubmitChangePasswordEvent extends ProfileEvents {
  final ChangePasswordRequest request;
  SubmitChangePasswordEvent(this.request);
}

class SubmitLogoutEvent extends ProfileEvents {}

sealed class ProfileUiEvents {}

class NavigateToLoginOnLogout extends ProfileUiEvents {}

class ShowProfileSuccessSnackBar extends ProfileUiEvents {
  final String message;
  ShowProfileSuccessSnackBar(this.message);
}

class ShowProfileErrorSnackBar extends ProfileUiEvents {
  final String message;
  ShowProfileErrorSnackBar(this.message);
}
