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
      child: ElevatedButton(
        style: _buildButtonStyle(theme),
        onPressed: isEnabled ? onPressed : null,
        child: _buildChild(theme, locale),
      ),
    );
  }

  ButtonStyle _buildButtonStyle(ThemeData theme) {
    return ElevatedButton.styleFrom(
      backgroundColor: isEnabled
          ? theme.colorScheme.primary
          : theme.disabledColor,
      disabledBackgroundColor: theme.colorScheme.onSurface.withValues(
        alpha: 0.40,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
    );
  }

  Widget _buildChild(ThemeData theme, AppLocalizations locale) {
    if (isLoading) {
      return CircularProgressIndicator(color: theme.colorScheme.onPrimary);
    }
    return Text(
      locale.updateButton,
      style: TextStyle(color: theme.colorScheme.onPrimary),
    );
  }
}
