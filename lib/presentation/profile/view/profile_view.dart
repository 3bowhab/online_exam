import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:online_exam/core/base/cubit/state_status.dart';
import 'package:online_exam/core/di/di.dart';
import 'package:online_exam/core/l10n/app_localizations.dart';
import 'package:online_exam/core/router/routers_constants.dart';
import 'package:online_exam/core/utils/validators.dart';
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
  StreamSubscription<ProfileUiEvents>? _uiSubscription;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Validators _validators = getIt<Validators>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  UserEntity? _originalUser;
  final ValueNotifier<bool> _isModifiedNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_checkIfModified);
    _firstNameController.addListener(_checkIfModified);
    _lastNameController.addListener(_checkIfModified);
    _emailController.addListener(_checkIfModified);
    _phoneController.addListener(_checkIfModified);
  }

  void _checkIfModified() {
    if (_originalUser == null) return;

    final hasChanged =
        _usernameController.text != (_originalUser?.username ?? '') ||
        _firstNameController.text != (_originalUser?.firstName ?? '') ||
        _lastNameController.text != (_originalUser?.lastName ?? '') ||
        _emailController.text != (_originalUser?.email ?? '') ||
        _phoneController.text != (_originalUser?.phone ?? '');

    if (hasChanged != _isModifiedNotifier.value) {
      _isModifiedNotifier.value = hasChanged;
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
    _uiSubscription?.cancel();
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
    _isModifiedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) {
        final cubit = getIt<ProfileCubit>();
        _uiSubscription = cubit.uiStream.listen(_handleUiEvents);
        return cubit..doIntent(FetchProfileDataEvent());
      },
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
        return _buildProfileContent(context, locale, theme, state);
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

      _isModifiedNotifier.value = false;
    }
  }

  Widget _buildProfileContent(
    BuildContext context,
    AppLocalizations locale,
    ThemeData theme,
    ProfileState state,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ProfileAvatar(),
            SizedBox(height: 20.h),
            _buildTextField(
              locale.usernameLabel,
              _usernameController,
              validator: (v) => _validators.validateUsername(
                v,
                locale,
              ),
            ),
            SizedBox(height: 12.h),
            _buildNameRow(locale),
            SizedBox(height: 12.h),
            _buildTextField(
              locale.emailLabel,
              _emailController,
              validator: (v) => _validators.validateEmail(
                v,
                locale,
              ),
            ),
            SizedBox(height: 12.h),
            const ProfilePasswordField(),
            SizedBox(height: 12.h),
            _buildTextField(
              locale.phoneNumberLabel,
              _phoneController,
              validator: (v) => _validators.validatePhone(
                v,
                locale,
              ),
            ),
            SizedBox(height: 24.h),
            ValueListenableBuilder<bool>(
              valueListenable: _isModifiedNotifier,
              builder: (context, isModified, child) {
                return ProfileUpdateButton(
                  isModified: isModified,
                  state: state,
                  onPressed: () => _onUpdatePressed(context),
                );
              },
            ),
            SizedBox(height: 12.h),
            ProfileLogoutButton(
              state: state,
              onPressed: () =>
                  context.read<ProfileCubit>().doIntent(SubmitLogoutEvent()),
            ),
            SizedBox(height: 16.h),
            const ProfileLanguageSelector(),
            SizedBox(height: 16.h),
            const ProfileThemeSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameRow(AppLocalizations locale) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            locale.firstNameLabel,
            _firstNameController,
            validator: (v) => _validators.validateRequired(
              v,
              locale,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildTextField(
            locale.lastNameLabel,
            _lastNameController,
            validator: (v) => _validators.validateRequired(
              v,
              locale,
            ),
          ),
        ),
      ],
    );
  }

  void _onUpdatePressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().doIntent(
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
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
