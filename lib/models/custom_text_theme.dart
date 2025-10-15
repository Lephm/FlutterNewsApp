import 'package:centranews/models/custom_color_scheme.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextTheme {
  CustomTextTheme({required this.currentColorScheme});

  CustomColorScheme currentColorScheme;

  TextStyle get bodyMedium {
    return GoogleFonts.inter(
      textStyle: TextStyle(color: currentColorScheme.textPrimary),
    );
  }

  TextStyle get bodyLightMedium {
    return GoogleFonts.inter(
      textStyle: TextStyle(color: currentColorScheme.textSecondary),
    );
  }

  TextStyle get bodyInverseMedium {
    return GoogleFonts.inter(
      textStyle: TextStyle(color: currentColorScheme.textInverse),
    );
  }

  TextStyle get bodyLarge {
    return GoogleFonts.inter(textStyle: TextStyle());
  }

  TextStyle get bodySmall {
    return GoogleFonts.inter(textStyle: TextStyle());
  }

  TextStyle get bodyBold {
    return GoogleFonts.inter(
      textStyle: TextStyle(
        fontSize: 15,
        color: currentColorScheme.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextStyle get headlineMedium {
    return GoogleFonts.inter(
      textStyle: TextStyle(fontSize: 30, color: currentColorScheme.textPrimary),
    );
  }
}
