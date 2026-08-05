import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_exam/core/constants/app_strings.dart';
import 'package:online_exam/core/l10n/app_localizations.dart';
import 'package:online_exam/core/utils/app_config_prvider.dart';
import 'package:online_exam/presentation/profile/widgets/selectable_card.dart';
import 'package:provider/provider.dart';

class ProfileLanguageSelector extends StatelessWidget {
  const ProfileLanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = AppLocalizations.of(context)!;
    final provider = Provider.of<AppConfigProvider>(context);
    final currentLang = provider.appLocale.languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.languageLabel,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        _buildCardsRow(provider, currentLang, locale),
      ],
    );
  }

  Widget _buildCardsRow(
    AppConfigProvider provider,
    String currentLang,
    AppLocalizations locale,
  ) {
    return Row(
      children: [
        Expanded(
          child: SelectableCard(
            title: locale.english,
            isSelected: currentLang == AppStrings.englishCode,
            onTap: () => provider.changeLanguage(AppStrings.englishCode),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: SelectableCard(
            title: locale.arabic,
            isSelected: currentLang == AppStrings.arabicCode,
            onTap: () => provider.changeLanguage(AppStrings.arabicCode),
          ),
        ),
      ],
    );
  }
}
