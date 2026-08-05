import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:online_exam/core/l10n/app_localizations.dart';
import 'package:online_exam/core/router/routers_constants.dart';

class ProfilePasswordField extends StatelessWidget {
  const ProfilePasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return TextFormField(
      initialValue: '••••••••',
      readOnly: true,
      decoration: InputDecoration(
        labelText: locale.passwordLabel,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        suffixIcon: TextButton(
          onPressed: () => context.push(RoutersConstants.profileResetPassword),
          child: Text(
            locale.changePasswordButton,
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
