import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_exam/core/utils/app_config_prvider.dart';
import 'package:online_exam/presentation/profile/widgets/selectable_card.dart';
import 'package:provider/provider.dart';

class ProfileThemeSelector extends StatelessWidget {
  const ProfileThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<AppConfigProvider>(context);
    final currentTheme = provider.currentThemeOption;
    final isArabic = provider.appLocale.languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'المظهر' : 'Theme',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: SelectableCard(
                title: isArabic ? 'فاتح' : 'Light',
                icon: Icons.light_mode_outlined,
                isSelected: currentTheme == ThemeOptions.light,
                onTap: () => provider.changeTheme(ThemeOptions.light),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: SelectableCard(
                title: isArabic ? 'داكن' : 'Dark',
                icon: Icons.dark_mode_outlined,
                isSelected: currentTheme == ThemeOptions.dark,
                onTap: () => provider.changeTheme(ThemeOptions.dark),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
