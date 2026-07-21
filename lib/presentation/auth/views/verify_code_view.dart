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
import 'package:pinput/pinput.dart';

class VerifyCodeView extends StatefulWidget {
  final String email;
  const VerifyCodeView({super.key, required this.email});

  @override
  State<VerifyCodeView> createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> {
  final AuthCubit cubit = getIt<AuthCubit>();
  final TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cubit.uiStream.listen((event) {
      if (!mounted) return;
      if (event is NavigateToResetPasswordScreen) {
        context.push('/reset_password', extra: widget.email);
      }
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final defaultPinTheme = PinTheme(
      width: 75.w,
      height: 60.h,
      textStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: theme.textTheme.bodyLarge?.color,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: theme.colorScheme.error),
      ),
    );

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
          child: Column(
            children: [
              SizedBox(height: 40.h),
              Text(
                locale.emailVerification,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                locale.emailVerificationSubTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              SizedBox(height: 32.h),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final bool isError =
                      state.verifyCodeState.status == StateStatus.error;
                  return Column(
                    children: [
                      Pinput(
                        controller: pinController,
                        length: 4,
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                        defaultPinTheme: defaultPinTheme,
                        errorPinTheme: errorPinTheme,
                        forceErrorState: isError,
                        onCompleted: (code) {
                          cubit.doIntent(SubmitVerifyCodeEvent(code));
                        },
                      ),
                      if (isError) ...[
                        SizedBox(height: 8.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                color: theme.colorScheme.error,
                                size: 16.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                state.verifyCodeState.message ??
                                    locale.invalidCode,
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    locale.didntReceiveCode,
                    style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  ),
                  GestureDetector(
                    onTap: () {
                      cubit.doIntent(SubmitEmailEvent(widget.email));
                    },
                    child: Text(
                      locale.resend,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
