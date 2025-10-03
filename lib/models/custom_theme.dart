import 'package:centranews/models/custom_color_scheme.dart';
import 'package:centranews/models/custom_text_theme.dart';

class CustomTheme {
  CustomTheme({required this.currentColorScheme})
    : textTheme = CustomTextTheme(currentColorScheme: currentColorScheme);

  CustomColorScheme currentColorScheme;
  CustomTextTheme textTheme;
}
