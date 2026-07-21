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
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final AuthCubit cubit = getIt<AuthCubit>();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    cubit.uiStream.listen((event) {
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
    });
  }

  @override
  void dispose() {
    emailController.dispose();
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
                    locale.forgetPassword,
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
                    locale.forgetPasswordSubTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final bool isError =
                        state.forgotPasswordState.status == StateStatus.error;
                    return TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: locale.email,
                        hintText: locale.enterYourEmail,
                        errorText: isError
                            ? (state.forgotPasswordState.message ??
                                  locale.invalidEmail)
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
                ),
                SizedBox(height: 48.h),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final bool isLoading =
                        state.forgotPasswordState.status == StateStatus.loading;
                    return ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                cubit.doIntent(
                                  SubmitEmailEvent(emailController.text.trim()),
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
