import 'package:flutter/material.dart';

enum ThemeBrightness { light, dark }

class CustomColorScheme {
  CustomColorScheme({
    required this.bgPrimary,
    required this.bgSecondary,
    required this.bgInverse,
    required this.textPrimary,
    required this.textSecondary,
    required this.textInverse,
    required this.themeType,
  });

  ThemeBrightness themeType;
  Color bgPrimary;
  Color bgSecondary;
  Color bgInverse;
  Color textPrimary;
  Color textSecondary;
  Color textInverse;
}

final lightTheme = CustomColorScheme(
  themeType: ThemeBrightness.light,
  bgPrimary: Colors.white,
  bgSecondary: const Color.fromARGB(255, 218, 218, 218),
  bgInverse: Color.fromARGB(198, 33, 33, 33),
  textPrimary: Colors.black,
  textSecondary: const Color.fromARGB(255, 102, 102, 102),
  textInverse: Colors.white,
);

final darkTheme = CustomColorScheme(
  themeType: ThemeBrightness.dark,
  bgPrimary: const Color.fromARGB(255, 37, 35, 35),
  bgSecondary: const Color.fromARGB(255, 112, 121, 140),
  bgInverse: const Color.fromARGB(255, 245, 241, 237),
  textPrimary: const Color.fromARGB(255, 245, 241, 237),
  textSecondary: const Color.fromARGB(255, 176, 188, 212),
  textInverse: const Color.fromARGB(255, 37, 35, 35),
);
