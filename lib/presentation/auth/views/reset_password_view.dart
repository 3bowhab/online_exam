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
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final AuthCubit cubit = getIt<AuthCubit>();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    cubit.uiStream.listen((event) {
      if (!mounted) return;
      if (event is NavigateToLoginScreen) {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: Text(
            locale.password,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),
                Center(
                  child: Text(
                    locale.resetPassword,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Center(
                  child: Text(
                    locale.resetPasswordSubTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: locale.newPassword,
                    hintText: locale.enterYourPassword,
                  ),
                  validator: (v) => v != null && v.length >= 6
                      ? null
                      : locale.invalidPassword,
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: locale.confirmPassword,
                    hintText: locale.confirmPassword,
                  ),
                  validator: (v) {
                    if (v != newPasswordController.text) {
                      return locale.passwordsDoNotMatch;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 48.h),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final bool isLoading =
                        state.resetPasswordState.status == StateStatus.loading;
                    return ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                cubit.doIntent(
                                  SubmitResetPasswordEvent(
                                    email: widget.email,
                                    newPassword: newPasswordController.text
                                        .trim(),
                                  ),
                                );
                              }
                            },
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
