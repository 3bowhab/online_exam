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

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => ForgotPasswordViewState();
}

class ForgotPasswordViewState extends State<ForgotPasswordView> {
  final AuthCubit _cubit = getIt<AuthCubit>();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cubit.uiStream.listen(_handleUiEvents);
  }

  void _handleUiEvents(AuthUiEvents event) {
    if (!mounted) return;
    if (event is NavigateToVerifyCodeScreen) {
      context.push('/verify_code', extra: event.email);
    } else if (event is ShowErrorSnackBar) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(event.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
            _buildEmailField(locale),
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
          locale.forgetPassword,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          locale.forgetPasswordSubTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(AppLocalizations locale) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final bool isError =
            state.forgotPasswordState.status == StateStatus.error;
        return TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: locale.email,
            hintText: locale.enterYourEmail,
            errorText: isError
                ? (state.forgotPasswordState.message ?? locale.invalidEmail)
                : null,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return locale.emailIsRequired;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildSubmitButton(AppLocalizations locale, ThemeData theme) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final bool isLoading =
            state.forgotPasswordState.status == StateStatus.loading;
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
      _cubit.doIntent(SubmitEmailEvent(_emailController.text.trim()));
    }
  }
}