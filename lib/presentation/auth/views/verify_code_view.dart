import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:online_exam/core/base/cubit/state_status.dart';
import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/core/router/routers_constants.dart';
import 'package:online_exam/core/l10n/app_localizations.dart';
import 'package:online_exam/presentation/auth/cubit/forget_password_flow_cubit.dart';
import 'package:online_exam/presentation/auth/cubit/forget_password_flow_events.dart';
import 'package:online_exam/presentation/auth/cubit/forget_password_flow_state.dart';
import 'package:pinput/pinput.dart';

class VerifyCodeView extends StatefulWidget {
  final String email;
  const VerifyCodeView({super.key, required this.email});

  @override
  State<VerifyCodeView> createState() => VerifyCodeViewState();
}

class VerifyCodeViewState extends State<VerifyCodeView> {
  final ForgetPasswordFlowCubit _cubit = getIt<ForgetPasswordFlowCubit>();
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit.uiStream.listen(_handleUiEvents);
  }

  void _handleUiEvents(AuthUiEvents event) {
    if (!mounted) return;
    if (event is NavigateToResetPasswordScreen) {
      context.push(RoutersConstants.resetPassword, extra: widget.email);
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
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
      child: Column(
        children: [
          SizedBox(height: 40.h),
          _buildHeader(locale, theme),
          SizedBox(height: 32.h),
          _buildPinSection(locale, theme),
          SizedBox(height: 32.h),
          _buildResendRow(locale, theme),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations locale, ThemeData theme) {
    return Column(
      children: [
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
      ],
    );
  }

  Widget _buildPinSection(AppLocalizations locale, ThemeData theme) {
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

    return BlocBuilder<ForgetPasswordFlowCubit, ForgetPasswordFlowState>(
      builder: (context, state) {
        final bool isError =
            state.verifyCodeState.status == StateStatus.error;
        return Column(
          children: [
            Pinput(
              controller: _pinController,
              length: 4,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              defaultPinTheme: defaultPinTheme,
              errorPinTheme: errorPinTheme,
              forceErrorState: isError,
              onCompleted: (code) {
                _cubit.doIntent(SubmitVerifyCodeEvent(code));
              },
            ),
            if (isError) _buildErrorMessage(state, locale, theme),
          ],
        );
      },
    );
  }

  Widget _buildErrorMessage(
      ForgetPasswordFlowState state, AppLocalizations locale, ThemeData theme) {
    return Column(
      children: [
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
                state.verifyCodeState.message ?? locale.invalidCode,
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResendRow(AppLocalizations locale, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          locale.didntReceiveCode,
          style: TextStyle(color: theme.textTheme.bodyMedium?.color),
        ),
        GestureDetector(
          onTap: () {
            _cubit.doIntent(SubmitEmailEvent(widget.email));
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
    );
  }
}