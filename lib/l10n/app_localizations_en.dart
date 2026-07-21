// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get password => 'Password';

  @override
  String get forgetPassword => 'Forget password';

  @override
  String get forgetPasswordSubTitle =>
      'Please enter your email associated to\nyour account';

  @override
  String get email => 'Email';

  @override
  String get enterYourEmail => 'Enter you email';

  @override
  String get emailIsRequired => 'Email is required';

  @override
  String get invalidEmail => 'This Email is not valid';

  @override
  String get continueButton => 'Continue';

  @override
  String get emailVerification => 'Email verification';

  @override
  String get emailVerificationSubTitle =>
      'Please enter your code that send to your\nemail address';

  @override
  String get invalidCode => 'Invalid code';

  @override
  String get didntReceiveCode => 'Didn\'t receive code? ';

  @override
  String get resend => 'Resend';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get resetPasswordSubTitle =>
      'Password must not be empty and must contain\n6 characters with upper case letter and one\nnumber at least';

  @override
  String get newPassword => 'New password';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get invalidPassword => 'Invalid password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';
}
