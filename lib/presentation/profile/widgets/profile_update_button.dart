import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_exam/core/base/cubit/state_status.dart';
import 'package:online_exam/core/l10n/app_localizations.dart';
import 'package:online_exam/presentation/profile/cubit/profile_state.dart';

class ProfileUpdateButton extends StatelessWidget {
  final bool isModified;
  final ProfileState state;
  final VoidCallback onPressed;

  const ProfileUpdateButton({
    super.key,
    required this.isModified,
    required this.state,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isLoading = state.editProfileState.status == StateStatus.loading;
    final isEnabled = isModified && !isLoading;

    return SizedBox(
      height: 48.h,
      child: ElevatedButton(
        style: _buildButtonStyle(theme, isEnabled),
        onPressed: isEnabled ? onPressed : null,
        child: _buildChild(theme, locale, isLoading),
      ),
    );
  }

  ButtonStyle _buildButtonStyle(ThemeData theme, bool isEnabled) {
    return ElevatedButton.styleFrom(
      backgroundColor: isEnabled
          ? theme.colorScheme.primary
          : theme.disabledColor,
      disabledBackgroundColor: theme.colorScheme.onSurface.withValues(
        alpha: 0.40,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
    );
  }

  Widget _buildChild(ThemeData theme, AppLocalizations locale, bool isLoading) {
    if (isLoading) {
      return CircularProgressIndicator(color: theme.colorScheme.onPrimary);
    }
    return Text(
      locale.updateButton,
      style: TextStyle(color: theme.colorScheme.onPrimary),
    );
  }
}
