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
  bgPrimary: Colors.black,
  bgSecondary: const Color.fromARGB(255, 237, 234, 234),
  bgInverse: Colors.white,
  textPrimary: Colors.white,
  textSecondary: const Color.fromARGB(255, 194, 194, 194),
  textInverse: Colors.black,
);
