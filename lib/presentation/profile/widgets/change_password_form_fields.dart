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
        TextFormField(
          controller: oldPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: locale.currentPasswordLabel,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? locale.requiredField : null,
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: newPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: locale.newPasswordLabel,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? locale.requiredField : null,
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: locale.confirmPasswordLabel,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return locale.requiredField;
            if (v != newPasswordController.text) {
              return locale.passwordNotMatched;
            }
            return null;
          },
        ),
      ],
    );
  }
}
