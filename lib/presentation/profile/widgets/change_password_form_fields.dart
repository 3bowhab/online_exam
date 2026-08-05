import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/core/l10n/app_localizations.dart';
import 'package:online_exam/core/utils/validators.dart';

class ChangePasswordFormFields extends StatelessWidget {
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  const ChangePasswordFormFields({
    super.key,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final validators = getIt<Validators>();

    return Column(children: _buildFieldsList(locale, validators));
  }

  List<Widget> _buildFieldsList(
    AppLocalizations locale,
    Validators validators,
  ) {
    return [
      _buildField(
        controller: oldPasswordController,
        label: locale.currentPasswordLabel,
        validator: (v) => validators.validateRequired(v, locale),
      ),
      SizedBox(height: 16.h),
      _buildField(
        controller: newPasswordController,
        label: locale.newPasswordLabel,
        validator: (v) => validators.validatePassword(v, locale),
      ),
      SizedBox(height: 16.h),
      _buildConfirmField(locale, validators),
    ];
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      validator: validator,
    );
  }

  Widget _buildConfirmField(AppLocalizations locale, Validators validators) {
    return TextFormField(
      controller: confirmPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: locale.confirmPasswordLabel,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      validator: (v) => validators.validateConfirmPassword(
        v,
        newPasswordController.text,
        locale,
      ),
    );
  }
}
