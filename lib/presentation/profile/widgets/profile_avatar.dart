import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Stack(
        children: [_buildMainAvatar(theme), _buildCameraBadge(theme)],
      ),
    );
  }

  Widget _buildMainAvatar(ThemeData theme) {
    return CircleAvatar(
      radius: 40.r,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.person,
        size: 40.sp,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildCameraBadge(ThemeData theme) {
    return Positioned(
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
    );
  }
}
