import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_exam/core/l10n/app_localizations.dart'; 
import 'package:online_exam/core/utils/app_config_prvider.dart';
import 'package:online_exam/presentation/profile/widgets/selectable_card.dart';
import 'package:provider/provider.dart';

class ProfileThemeSelector extends StatelessWidget {
  const ProfileThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = AppLocalizations.of(context)!;
    final provider = Provider.of<AppConfigProvider>(context);
    final currentTheme = provider.currentThemeOption;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.themeTitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        _buildThemeCardsRow(provider, currentTheme, locale),
      ],
    );
  }

  Widget _buildThemeCardsRow(
    AppConfigProvider provider,
    ThemeOptions currentTheme,
    AppLocalizations locale,
  ) {
    return Row(
      children: [
        Expanded(
          child: SelectableCard(
            title: locale.lightTheme,
            icon: Icons.light_mode_outlined,
            isSelected: currentTheme == ThemeOptions.light,
            onTap: () => provider.changeTheme(ThemeOptions.light),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: SelectableCard(
            title: locale.darkTheme,
            icon: Icons.dark_mode_outlined,
            isSelected: currentTheme == ThemeOptions.dark,
            onTap: () => provider.changeTheme(ThemeOptions.dark),
          ),
        ),
      ],
    );
  }
}