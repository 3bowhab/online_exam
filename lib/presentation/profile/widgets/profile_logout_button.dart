import 'package:flutter/material.dart';
import 'package:online_exam/core/base/cubit/state_status.dart';
import 'package:online_exam/core/l10n/app_localizations.dart';
import 'package:online_exam/presentation/profile/cubit/profile_state.dart';

class ProfileLogoutButton extends StatelessWidget {
  final ProfileState state;
  final VoidCallback onPressed;

  const ProfileLogoutButton({
    super.key,
    required this.state,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isLoading = state.logoutState.status == StateStatus.loading;

    return SizedBox(
      height: 48,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildChild(theme, locale, isLoading),
      ),
    );
  }

  Widget _buildChild(ThemeData theme, AppLocalizations locale, bool isLoading) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: theme.colorScheme.error,
          strokeWidth: 2,
        ),
      );
    }
    return Text(
      locale.logout,
      style: theme.textTheme.titleMedium?.copyWith(
        color: theme.colorScheme.error,
      ),
    );
  }
}
