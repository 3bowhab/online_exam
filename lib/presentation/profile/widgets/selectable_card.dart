import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectableCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableCard({
    super.key,
    required this.title,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: _buildDecoration(theme),
        child: _buildCardContent(theme),
      ),
    );
  }

  BoxDecoration _buildDecoration(ThemeData theme) {
    return BoxDecoration(
      color: isSelected
          ? theme.colorScheme.primary
          : theme.scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.inputDecorationTheme.enabledBorder?.borderSide.color ??
                  theme.dividerColor,
        width: isSelected ? 2 : 1,
      ),
    );
  }

  Widget _buildCardContent(ThemeData theme) {
    final activeColor = theme.colorScheme.onPrimary;
    final inactiveColor = theme.textTheme.bodyLarge?.color;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isSelected ? Icons.check_circle : (icon ?? Icons.language),
          size: 18.sp,
          color: isSelected ? activeColor : inactiveColor,
        ),
        SizedBox(width: 6.w),
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? activeColor : inactiveColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
