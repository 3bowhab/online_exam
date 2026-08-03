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
import 'package:online_exam/presentation/profile/widgets/profile_avatar.dart';
import 'package:online_exam/presentation/profile/widgets/profile_language_selector.dart';
import 'package:online_exam/presentation/profile/widgets/profile_logout_button.dart';
import 'package:online_exam/presentation/profile/widgets/profile_password_field.dart';
import 'package:online_exam/presentation/profile/widgets/profile_theme_selector.dart';
import 'package:online_exam/presentation/profile/widgets/profile_update_button.dart';

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

  UserEntity? _originalUser;
  bool _isModified = false;

  @override
  void initState() {
    super.initState();
    _uiSubscription = _cubit.uiStream.listen(_handleUiEvents);

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
    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    switch (event) {
      case NavigateToLoginOnLogout():
        context.go(RoutersConstants.login);
        break;

      case ShowProfileSuccessSnackBar(:final message):
        final translatedMessage = message == 'profileUpdatedSuccessfully'
            ? locale.profileUpdatedSuccessfully
            : message == 'passwordChangedSuccessfully'
            ? locale.passwordChangedSuccessfully
            : message;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(translatedMessage),
            backgroundColor: theme.colorScheme.tertiary,
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

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: Text(locale.profileTitle), centerTitle: false),
        body: _buildBlocConsumer(locale),
      ),
    );
  }

  Widget _buildBlocConsumer(AppLocalizations locale) {
    final theme = Theme.of(context);

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: _onStateListener,
      builder: (context, state) {
        if (state.profileDataState.status == StateStatus.loading) {
          return Center(
            child: CircularProgressIndicator(color: theme.colorScheme.primary),
          );
        }
        return _buildProfileContent(locale, theme, state);
      },
    );
  }

  void _onStateListener(BuildContext context, ProfileState state) {
    if (state.profileDataState.status == StateStatus.success &&
        state.profileDataState.data != null) {
      final user = state.profileDataState.data!;
      _originalUser = user;
      _usernameController.text = user.username;
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _emailController.text = user.email;
      _phoneController.text = user.phone;

      setState(() => _isModified = false);
    }
  }

  Widget _buildProfileContent(
    AppLocalizations locale,
    ThemeData theme,
    ProfileState state,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProfileAvatar(),
          SizedBox(height: 20.h),
          _buildTextField(locale.usernameLabel, _usernameController),
          SizedBox(height: 12.h),
          _buildNameRow(locale),
          SizedBox(height: 12.h),
          _buildTextField(locale.emailLabel, _emailController),
          SizedBox(height: 12.h),
          const ProfilePasswordField(),
          SizedBox(height: 12.h),
          _buildTextField(locale.phoneNumberLabel, _phoneController),
          SizedBox(height: 24.h),
          ProfileUpdateButton(
            isModified: _isModified,
            state: state,
            onPressed: _onUpdatePressed,
          ),
          SizedBox(height: 12.h),
          ProfileLogoutButton(
            state: state,
            onPressed: () => _cubit.doIntent(SubmitLogoutEvent()),
          ),
          SizedBox(height: 16.h),
          const ProfileLanguageSelector(),
          SizedBox(height: 16.h),
          const ProfileThemeSelector(),
        ],
      ),
    );
  }

  Widget _buildNameRow(AppLocalizations locale) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(locale.firstNameLabel, _firstNameController),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildTextField(locale.lastNameLabel, _lastNameController),
        ),
      ],
    );
  }

  void _onUpdatePressed() {
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
