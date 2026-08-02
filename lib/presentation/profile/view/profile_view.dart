import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:online_exam/core/base/cubit/state_status.dart';
import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/core/l10n/app_localizations.dart';
import 'package:online_exam/core/router/routers_constants.dart';
import 'package:online_exam/data/models/profile/edit_profile_request.dart';
import 'package:online_exam/domain/entities/user_entity.dart';
import 'package:online_exam/presentation/profile/cubit/profile_cubit.dart';
import 'package:online_exam/presentation/profile/cubit/profile_events.dart';
import 'package:online_exam/presentation/profile/cubit/profile_state.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  final ProfileCubit _cubit = getIt<ProfileCubit>();
  late StreamSubscription<ProfileUiEvents> _uiSubscription;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // الاحتفاظ بنسخة من البيانات الأصلية القادمة من ה-API
  UserEntity? _originalUser;
  bool _isModified = false;

  @override
  void initState() {
    super.initState();
    _uiSubscription = _cubit.uiStream.listen(_handleUiEvents);

    // إضافة المستمعين لمعرفة هل تم التعديل على أي حقل أم لا
    _usernameController.addListener(_checkIfModified);
    _firstNameController.addListener(_checkIfModified);
    _lastNameController.addListener(_checkIfModified);
    _emailController.addListener(_checkIfModified);
    _phoneController.addListener(_checkIfModified);

    _cubit.doIntent(FetchProfileDataEvent());
  }

  void _checkIfModified() {
    if (_originalUser == null) return;

    final hasChanged =
        _usernameController.text != (_originalUser?.username ?? '') ||
        _firstNameController.text != (_originalUser?.firstName ?? '') ||
        _lastNameController.text != (_originalUser?.lastName ?? '') ||
        _emailController.text != (_originalUser?.email ?? '') ||
        _phoneController.text != (_originalUser?.phone ?? '');

    if (hasChanged != _isModified) {
      setState(() {
        _isModified = hasChanged;
      });
    }
  }

  void _handleUiEvents(ProfileUiEvents event) {
    if (!mounted) return;
    final theme = Theme.of(context);

    switch (event) {
      case NavigateToLoginOnLogout():
        context.go(RoutersConstants.login);
        break;

      case ShowProfileSuccessSnackBar(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: theme.colorScheme.primary,
          ),
        );
        break;

      case ShowProfileErrorSnackBar(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: theme.colorScheme.error,
          ),
        );
        break;
    }
  }

  @override
  void dispose() {
    _uiSubscription.cancel();
    _usernameController.removeListener(_checkIfModified);
    _firstNameController.removeListener(_checkIfModified);
    _lastNameController.removeListener(_checkIfModified);
    _emailController.removeListener(_checkIfModified);
    _phoneController.removeListener(_checkIfModified);

    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: Text(locale.profileTitle), centerTitle: false),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.profileDataState.status == StateStatus.success &&
                state.profileDataState.data != null) {
              final user = state.profileDataState.data!;
              _originalUser = user;
              _usernameController.text = user.username;
              _firstNameController.text = user.firstName;
              _lastNameController.text = user.lastName;
              _emailController.text = user.email;
              _phoneController.text = user.phone;

              setState(() {
                _isModified = false;
              });
            }
          },
          builder: (context, state) {
            if (state.profileDataState.status == StateStatus.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildAvatarSection(theme),
                  SizedBox(height: 20.h),
                  _buildTextField(locale.usernameLabel, _usernameController),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          locale.firstNameLabel,
                          _firstNameController,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildTextField(
                          locale.lastNameLabel,
                          _lastNameController,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _buildTextField(locale.emailLabel, _emailController),
                  SizedBox(height: 12.h),
                  _buildPasswordField(context, locale, theme),
                  SizedBox(height: 12.h),
                  _buildTextField(locale.phoneNumberLabel, _phoneController),
                  SizedBox(height: 24.h),
                  _buildUpdateButton(locale, theme, state),
                  SizedBox(height: 12.h),
                  _buildLogoutButton(locale, theme, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatarSection(ThemeData theme) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.person,
              size: 40.sp,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 12.r,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(
                Icons.camera_alt,
                size: 14.sp,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  Widget _buildPasswordField(
    BuildContext context,
    AppLocalizations locale,
    ThemeData theme,
  ) {
    return TextFormField(
      initialValue: '••••••••',
      readOnly: true,
      decoration: InputDecoration(
        labelText: locale.passwordLabel,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        suffixIcon: TextButton(
          onPressed: () {
            context.push(RoutersConstants.profileResetPassword);
          },
          child: Text(
            locale.changePasswordButton,
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton(
    AppLocalizations locale,
    ThemeData theme,
    ProfileState state,
  ) {
    final isLoading = state.editProfileState.status == StateStatus.loading;
    // يكون الزر مفعلاً فقط إذا تم تعديل أي قيمة وكان غير جارٍ التحميل
    final isEnabled = _isModified && !isLoading;

    return SizedBox(
      height: 48.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? theme.colorScheme.primary
              : theme.disabledColor,
          disabledBackgroundColor: theme.colorScheme.onSurface.withValues(
            alpha: 0.12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        onPressed: isEnabled
            ? () {
                _cubit.doIntent(
                  SubmitEditProfileEvent(
                    EditProfileRequest(
                      username: _usernameController.text,
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      email: _emailController.text,
                      phone: _phoneController.text,
                    ),
                  ),
                );
              }
            : null,
        child: isLoading
            ? CircularProgressIndicator(color: theme.colorScheme.onPrimary)
            : Text(
                locale.updateButton,
                style: TextStyle(
                  color: isEnabled
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                ),
              ),
      ),
    );
  }

  Widget _buildLogoutButton(
    AppLocalizations locale,
    ThemeData theme,
    ProfileState state,
  ) {
    final isLoading = state.logoutState.status == StateStatus.loading;

    return SizedBox(
      height: 48.h,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.colorScheme.error),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        onPressed: isLoading
            ? null
            : () => _cubit.doIntent(SubmitLogoutEvent()),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  color: theme.colorScheme.error,
                  strokeWidth: 2,
                ),
              )
            : Text(
                locale.logout,
                style: TextStyle(color: theme.colorScheme.error),
              ),
      ),
    );
  }
}
