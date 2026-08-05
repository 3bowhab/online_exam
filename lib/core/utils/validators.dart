import 'package:injectable/injectable.dart';
import 'package:online_exam/core/l10n/app_localizations.dart';

@injectable
class Validators {
  String? validateRequired(String? value, AppLocalizations locale) {
    if (value == null || value.trim().isEmpty) {
      return locale.requiredField;
    }
    return null;
  }

  String? validateEmail(String? value, AppLocalizations locale) {
    if (value == null || value.trim().isEmpty) {
      return locale.requiredField;
    }
    
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    
    if (!emailRegExp.hasMatch(value.trim())) {
      return locale.invalidEmail;
    }
    return null;
  }

  String? validatePassword(String? value, AppLocalizations locale) {
    if (value == null || value.trim().isEmpty) {
      return locale.requiredField;
    }
    if (value.length < 6) {
      return locale.passwordTooShort;
    }
    return null;
  }

  String? validateConfirmPassword(
    String? value,
    String? password,
    AppLocalizations locale,
  ) {
    if (value == null || value.trim().isEmpty) {
      return locale.requiredField;
    }
    if (value != password) {
      return locale.passwordNotMatched;
    }
    return null;
  }

  String? validatePhone(String? value, AppLocalizations locale) {
    if (value == null || value.trim().isEmpty) {
      return locale.requiredField;
    }
    
    final phoneRegExp = RegExp(r'^01[0125][0-9]{8}$');
    
    if (!phoneRegExp.hasMatch(value.trim())) {
      return locale.invalidPhoneNumber;
    }
    return null;
  }

  String? validateUsername(String? value, AppLocalizations locale) {
    if (value == null || value.trim().isEmpty) {
      return locale.requiredField;
    }
    if (value.trim().length < 3) {
      return locale.usernameTooShort;
    }
    return null;
  }
}