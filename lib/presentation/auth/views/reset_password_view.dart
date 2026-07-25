import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:online_exam/core/base/cubit/state_status.dart';
import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/l10n/app_localizations.dart';
import 'package:online_exam/presentation/auth/cubit/auth_cubit.dart';
import 'package:online_exam/presentation/auth/cubit/auth_events.dart';
import 'package:online_exam/presentation/auth/cubit/auth_state.dart';

class ResetPasswordView extends StatefulWidget {
  final String email;
  const ResetPasswordView({super.key, required this.email});

  @override
  State<ResetPasswordView> createState() => ResetPasswordViewState();
}

class ResetPasswordViewState extends State<ResetPasswordView> {
  final AuthCubit _cubit = getIt<AuthCubit>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cubit.uiStream.listen(_handleUiEvents);
  }

  void _handleUiEvents(AuthUiEvents event) {
    if (!mounted) return;
    if (event is NavigateToLoginScreen) {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: _buildAppBar(locale),
        body: _buildBody(locale, theme),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations locale) {
    return AppBar(
      leading: const BackButton(),
      title: Text(
        locale.password,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildBody(AppLocalizations locale, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40.h),
            _buildHeader(locale, theme),
            SizedBox(height: 32.h),
            _buildPasswordFields(locale),
            SizedBox(height: 48.h),
            _buildSubmitButton(locale, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations locale, ThemeData theme) {
    return Column(
      children: [
        Text(
          locale.resetPassword,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          locale.resetPasswordSubTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordFields(AppLocalizations locale) {
    return Column(
      children: [
        TextFormField(
          controller: _newPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: locale.newPassword,
            hintText: locale.enterYourPassword,
          ),
          validator: (v) =>
              v != null && v.length >= 6 ? null : locale.invalidPassword,
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: locale.confirmPassword,
            hintText: locale.confirmPassword,
          ),
          validator: (v) {
            if (v != _newPasswordController.text) {
              return locale.passwordsDoNotMatch;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(AppLocalizations locale, ThemeData theme) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final bool isLoading =
            state.resetPasswordState.status == StateStatus.loading;
        return ElevatedButton(
          onPressed: isLoading ? null : _onSubmit,
          child: isLoading
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : Text(locale.continueButton),
        );
      },
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      _cubit.doIntent(
        SubmitResetPasswordEvent(
          email: widget.email,
          newPassword: _newPasswordController.text.trim(),
        ),
      );
    }
  }
}