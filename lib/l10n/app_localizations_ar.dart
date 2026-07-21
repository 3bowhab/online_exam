// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get helloWorld => 'مرحبا بالعالم!';

  @override
  String get password => 'كلمة السر';

  @override
  String get forgetPassword => 'نسيت كلمة السر';

  @override
  String get forgetPasswordSubTitle =>
      'يرجى إدخال البريد الإلكتروني المرتبط\nبحسابك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get enterYourEmail => 'أدخل البريد الإلكتروني';

  @override
  String get emailIsRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get invalidEmail => 'هذا البريد الإلكتروني غير صالح';

  @override
  String get continueButton => 'متابعة';

  @override
  String get emailVerification => 'تأكيد البريد الإلكتروني';

  @override
  String get emailVerificationSubTitle =>
      'يرجى إدخال الكود المرسل إلى\nبريدك الإلكتروني';

  @override
  String get invalidCode => 'الكود غير صالح';

  @override
  String get didntReceiveCode => 'لم تصلك الرسالة؟ ';

  @override
  String get resend => 'إعادة إرسال';

  @override
  String get resetPassword => 'إعادة تعيين كلمة السر';

  @override
  String get resetPasswordSubTitle =>
      'يجب ألا تكون كلمة السر فارغة وأن تحتوي على\n 6 أحرف على الأقل مع حرف كبير ورقم واحد على الأقل';

  @override
  String get newPassword => 'كلمة السر الجديدة';

  @override
  String get enterYourPassword => 'أدخل كلمة السر';

  @override
  String get confirmPassword => 'تأكيد كلمة السر';

  @override
  String get invalidPassword => 'كلمة السر غير صالحة';

  @override
  String get passwordsDoNotMatch => 'كلمات السر غير متطابقة';
}
