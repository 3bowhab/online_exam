import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_exam/core/utils/app_config_prvider.dart';
import 'package:online_exam/presentation/profile/widgets/selectable_card.dart';
import 'package:provider/provider.dart';

class ProfileLanguageSelector extends StatelessWidget {
  const ProfileLanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<AppConfigProvider>(context);
    final currentLang = provider.appLocale.languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currentLang == 'ar' ? 'اللغة' : 'Language',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: SelectableCard(
                title: 'English',
                isSelected: currentLang == 'en',
                onTap: () => provider.changeLanguage('en'),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: SelectableCard(
                title: 'العربية',
                isSelected: currentLang == 'ar',
                onTap: () => provider.changeLanguage('ar'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
