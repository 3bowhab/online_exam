import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_exam/core/l10n/app_localizations.dart';

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

    return Column(
      children: [
        _buildField(
          controller: oldPasswordController,
          label: locale.currentPasswordLabel,
          validator: (v) =>
              v == null || v.isEmpty ? locale.requiredField : null,
        ),
        SizedBox(height: 16.h),
        _buildField(
          controller: newPasswordController,
          label: locale.newPasswordLabel,
          validator: (v) =>
              v == null || v.isEmpty ? locale.requiredField : null,
        ),
        SizedBox(height: 16.h),
        _buildConfirmField(locale),
      ],
    );
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

  Widget _buildConfirmField(AppLocalizations locale) {
    return TextFormField(
      controller: confirmPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: locale.confirmPasswordLabel,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return locale.requiredField;
        if (v != newPasswordController.text) return locale.passwordNotMatched;
        return null;
      },
    );
  }
}
