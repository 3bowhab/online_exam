import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_exam/core/l10n/app_localizations.dart';

class ChangePasswordSubmitButton extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onPressed;

  const ChangePasswordSubmitButton({
    super.key,
    required this.isEnabled,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SizedBox(
      height: 48.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        child: _buildChild(theme, locale),
      ),
    );
  }

  Widget _buildChild(ThemeData theme, AppLocalizations locale) {
    if (isLoading) {
      return SizedBox(
        height: 24.h,
        width: 24.w,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: theme.colorScheme.onPrimary,
        ),
      );
    }
    return Text(locale.updateButton);
  }
}