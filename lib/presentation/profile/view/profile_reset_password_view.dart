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
import 'package:online_exam/presentation/profile/widgets/change_password_form_fields.dart';
import 'package:online_exam/presentation/profile/widgets/change_password_submit_button.dart';

class ProfileResetPasswordView extends StatefulWidget {
  const ProfileResetPasswordView({super.key});

  @override
  State<ProfileResetPasswordView> createState() =>
      ProfileResetPasswordViewState();
}

class ProfileResetPasswordViewState extends State<ProfileResetPasswordView> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> _isFormFilledNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _oldPasswordController.addListener(_checkIfFormFilled);
    _newPasswordController.addListener(_checkIfFormFilled);
    _confirmPasswordController.addListener(_checkIfFormFilled);
  }

  void _checkIfFormFilled() {
    final isFilled =
        _oldPasswordController.text.trim().isNotEmpty &&
        _newPasswordController.text.trim().isNotEmpty &&
        _confirmPasswordController.text.trim().isNotEmpty;

    if (isFilled != _isFormFilledNotifier.value) {
      _isFormFilledNotifier.value = isFilled;
    }
  }

  @override
  void dispose() {
    _oldPasswordController.removeListener(_checkIfFormFilled);
    _newPasswordController.removeListener(_checkIfFormFilled);
    _confirmPasswordController.removeListener(_checkIfFormFilled);

    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _isFormFilledNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(locale.resetPasswordTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.changePasswordState.status == StateStatus.success) {
          context.pop();
        }
      },
      builder: (context, state) {
        final isLoading =
            state.changePasswordState.status == StateStatus.loading;
        return _buildForm(context, isLoading);
      },
    );
  }

  Widget _buildForm(BuildContext context, bool isLoading) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ChangePasswordFormFields(
              oldPasswordController: _oldPasswordController,
              newPasswordController: _newPasswordController,
              confirmPasswordController: _confirmPasswordController,
            ),
            SizedBox(height: 32.h),
            ValueListenableBuilder<bool>(
              valueListenable: _isFormFilledNotifier,
              builder: (context, isFormFilled, child) {
                final isEnabled = isFormFilled && !isLoading;
                return ChangePasswordSubmitButton(
                  isEnabled: isEnabled,
                  isLoading: isLoading,
                  onPressed: () => _onSubmit(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().doIntent(
        SubmitChangePasswordEvent(
          ChangePasswordRequest(
            oldPassword: _oldPasswordController.text,
            password: _newPasswordController.text,
            rePassword: _confirmPasswordController.text,
          ),
        ),
      );
    }
  }
}
