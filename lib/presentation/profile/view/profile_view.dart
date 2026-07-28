import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:online_exam/core/base/cubit/state_status.dart';
import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/presentation/profile/cubit/profile_state.dart';
import 'package:online_exam/core/l10n/app_localizations.dart';
import 'package:online_exam/core/router/routers_constants.dart';
import 'package:online_exam/presentation/profile/cubit/profile_cubit.dart';
import 'package:online_exam/presentation/profile/cubit/profile_events.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  final ProfileCubit _cubit = getIt<ProfileCubit>();
  late StreamSubscription<ProfileUiEvents> _uiSubscription;

  @override
  void initState() {
    super.initState();
    _uiSubscription = _cubit.uiStream.listen(_handleUiEvents);
  }

  void _handleUiEvents(ProfileUiEvents event) {
    if (!mounted) return;
    switch (event) {
      case NavigateToLoginOnLogout():
        context.go(RoutersConstants.login);
        break;

      case ShowProfileErrorSnackBar(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        break;
    }
  }

  @override
  void dispose() {
    _uiSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: Text(locale.profileTitle)),
        body: _buildBody(locale, theme),
      ),
    );
  }

  Widget _buildBody(AppLocalizations locale, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(locale.helloWorld),
          SizedBox(height: 16.h),
          _buildLogoutButton(locale, theme),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(AppLocalizations locale, ThemeData theme) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final bool isLoading = state.logoutState.status == StateStatus.loading;

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            padding: EdgeInsets.symmetric(vertical: 12.h),
          ),
          onPressed: isLoading
              ? null
              : () => _cubit.doIntent(SubmitLogoutEvent()),
          child: isLoading
              ? _buildLoadingIndicator(theme)
              : Text(
                  locale.logout,
                  style: TextStyle(
                    color: theme.colorScheme.onError,
                  ),
                ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return SizedBox(
      height: 20.h,
      width: 20.w,
      child: CircularProgressIndicator(
        color: theme.colorScheme.onError,
        strokeWidth: 2,
      ),
    );
  }
}