import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:online_exam/core/base/cubit/state_status.dart';
import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/core/l10n/app_localizations.dart';
import 'package:online_exam/data/models/profile/change_password_request.dart';
import 'package:online_exam/presentation/profile/cubit/profile_cubit.dart';
import 'package:online_exam/presentation/profile/cubit/profile_events.dart';
import 'package:online_exam/presentation/profile/cubit/profile_state.dart';

class ProfileResetPasswordView extends StatefulWidget {
  const ProfileResetPasswordView({super.key});

  @override
  State<ProfileResetPasswordView> createState() => _ProfileResetPasswordViewState();
}

class _ProfileResetPasswordViewState extends State<ProfileResetPasswordView> {
  final ProfileCubit _cubit = getIt<ProfileCubit>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _oldPasswordController.dispose();
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
        appBar: AppBar(
          title: Text(locale.resetPasswordTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.changePasswordState.status == StateStatus.success) {
              context.pop(); // العودة لشاشة البروفايل عند التغير بنجاح
            }
          },
          builder: (context, state) {
            final isLoading =
                state.changePasswordState.status == StateStatus.loading;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _oldPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: locale.currentPasswordLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? locale.requiredField : null,
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: locale.newPasswordLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? locale.requiredField : null,
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: locale.confirmPasswordLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return locale.requiredField;
                        if (v != _newPasswordController.text) {
                          return locale.passwordNotMatched;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32.h),
                    SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  _cubit.doIntent(
                                    SubmitChangePasswordEvent(
                                      ChangePasswordRequest(
                                        oldPassword:
                                            _oldPasswordController.text,
                                        password: _newPasswordController.text,
                                        rePassword:
                                            _confirmPasswordController.text,
                                      ),
                                    ),
                                  );
                                }
                              },
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: theme.colorScheme.onPrimary,
                              )
                            : Text(
                                locale.updateButton,
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}