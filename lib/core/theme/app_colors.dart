import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

// Define an abstract class for app colors
abstract class AppColors {
  MaterialColor get blue;
  MaterialColor get black;
  Color get sucess;
  Color get error;
  Color get gray;
  Color get white;
  Color get lightBlue;
  Color get lightGreen;
  Color get lightRed;
  Color get placeHolder;
}

// Implement the AppColors interface for light theme colors
@Singleton(as: AppColors)
class LightThemeColors implements AppColors {
  @override
  MaterialColor get blue => const MaterialColor(0xFF02369C, {
    50: Color(0xFFCCD7EB),
    100: Color(0xFFABBCDE),
    200: Color(0xFF819BCE),
    300: Color(0xFF5679BD),
    400: Color(0xFF2C58AD),
    500: Color(0xFF02369C),
    600: Color(0xFF022D82),
    700: Color(0xFF012468),
    800: Color(0xFF011B4E),
    900: Color(0xFF011234),
  });

  @override
  MaterialColor get black => const MaterialColor(0xFF0F0F0F, {
    50: Color(0xFFCFCFCF),
    100: Color(0xFFAFAFAF),
    200: Color(0xFF878787),
    300: Color(0xFF5F5F5F),
    400: Color(0xFF373737),
    500: Color(0xFF0F0F0F),
    600: Color(0xFF0D0D0D),
    700: Color(0xFF0A0A0A),
    800: Color(0xFF080808),
    900: Color(0xFF050505),
  });

  @override
  Color get sucess => const Color(0xFF11CE19);

  @override
  Color get error => const Color(0xFFCC1010);

  @override
  Color get gray => const Color(0xFF535353);

  @override
  Color get white => const Color(0xFFF9F9F9);

  @override
  Color get lightBlue => const Color(0xFFEDEFF3);

  @override
  Color get lightGreen => const Color(0xFFCAF9CC);

  @override
  Color get lightRed => const Color(0xFFF8D2D2);

  @override
  Color get placeHolder => const Color(0xFFA6A6A6);
}
