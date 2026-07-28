import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:online_exam/core/base/cubit/state_status.dart';
import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/core/l10n/app_localizations.dart';
import 'package:online_exam/core/router/routers_constants.dart';
import 'package:online_exam/presentation/auth/cubit/login_cubit.dart';
import 'package:online_exam/presentation/auth/cubit/login_events.dart';
import 'package:online_exam/presentation/auth/cubit/login_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final LoginCubit _cubit = getIt<LoginCubit>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _rememberMe = false;
  bool _isPasswordObscured = true;
  late StreamSubscription<LoginUiEvents> _uiSubscription;

  @override
  void initState() {
    super.initState();
    _uiSubscription = _cubit.uiStream.listen(_handleUiEvents);
    _loadSavedEmail(); 
  }

  void _loadSavedEmail() {
    final savedEmail = _cubit.getSavedEmail();
    if (savedEmail != null && savedEmail.isNotEmpty) {
      setState(() {
        _emailController.text = savedEmail;
        _rememberMe = true;
      });
    }
  }

  void _handleUiEvents(LoginUiEvents event) {
    if (!mounted) return;
    switch (event) {
      case NavigateToHomeScreen():
        context.go(RoutersConstants.profile);
        break;

      case ShowLoginErrorSnackBar(:final message):
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
    _emailController.dispose();
    _passwordController.dispose();
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
        locale.login,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildBody(AppLocalizations locale, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 32.h),
              _buildInputFields(locale),
              SizedBox(height: 8.h),
              _buildRememberAndForgotRow(locale, theme),
              SizedBox(height: 32.h),
              _buildSubmitButton(locale, theme),
              SizedBox(height: 16.h),
              _buildSignUpRow(locale, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputFields(AppLocalizations locale) {
    return Column(
      children: [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: locale.email,
            hintText: locale.enterYourEmail,
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return locale.invalidEmail;
            }
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(v.trim())) {
              return locale.invalidEmail;
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _passwordController,
          obscureText: _isPasswordObscured,
          decoration: InputDecoration(
            labelText: locale.password,
            hintText: locale.enterYourPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordObscured
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordObscured = !_isPasswordObscured;
                });
              },
            ),
          ),
          validator: (v) =>
              v != null && v.length >= 6 ? null : locale.invalidPassword,
        ),
      ],
    );
  }

  Widget _buildRememberAndForgotRow(AppLocalizations locale, ThemeData theme) {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (v) {
            setState(() {
              _rememberMe = v ?? false;
            });
          },
        ),
        Text(locale.rememberMe, style: TextStyle(fontSize: 13.sp)),
        const Spacer(),
        GestureDetector(
          onTap: () {
            context.push(RoutersConstants.forgotPassword);
          },
          child: Text(
            locale.forgotPassword,
            style: TextStyle(
              fontSize: 13.sp,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
              color: theme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(AppLocalizations locale, ThemeData theme) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final bool isLoading = state.loginState.status == StateStatus.loading;

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
              : Text(locale.login),
        );
      },
    );
  }

  Widget _buildSignUpRow(AppLocalizations locale, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(locale.dontHaveAccount, style: TextStyle(fontSize: 14.sp)),
        GestureDetector(
          onTap: () {
            context.push(RoutersConstants.profile);
          },
          child: Text(
            locale.signUp,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      _cubit.doIntent(
        SubmitLoginEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          rememberMe: _rememberMe,
        ),
      );
    }
  }
}
