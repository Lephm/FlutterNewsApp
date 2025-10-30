import 'package:centranews/models/custom_color_scheme.dart';
import 'package:centranews/models/custom_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = NotifierProvider<ThemeNotifier, CustomTheme>(
  () => ThemeNotifier(),
);

class ThemeNotifier extends Notifier<CustomTheme> {
  @override
  CustomTheme build() {
    return CustomTheme(currentColorScheme: darkTheme);
  }
}
