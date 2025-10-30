import 'package:centranews/models/custom_color_scheme.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextTheme {
  CustomTextTheme({required this.currentColorScheme});

  CustomColorScheme currentColorScheme;

  TextStyle get bodyMedium {
    return GoogleFonts.lato(
      textStyle: TextStyle(color: currentColorScheme.textPrimary),
    );
  }

  TextStyle get bodyLightMedium {
    return GoogleFonts.lato(
      textStyle: TextStyle(color: currentColorScheme.textSecondary),
    );
  }

  TextStyle get bodyMediumBold {
    return GoogleFonts.lato(
      textStyle: TextStyle(
        color: currentColorScheme.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextStyle get bodyInverseMedium {
    return GoogleFonts.lato(
      textStyle: TextStyle(color: currentColorScheme.textInverse),
    );
  }

  TextStyle get bodyLarge {
    return GoogleFonts.lato(textStyle: TextStyle());
  }

  TextStyle get bodySmall {
    return GoogleFonts.lato(
      textStyle: TextStyle(fontSize: 15, color: currentColorScheme.textPrimary),
    );
  }

  TextStyle get smallLabelBold {
    return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 10,
        color: currentColorScheme.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextStyle get smallLabelBoldInverse {
    return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 10,
        color: currentColorScheme.textInverse,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextStyle get bodyBold {
    return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 15,
        color: currentColorScheme.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextStyle get headlineMedium {
    return GoogleFonts.lato(
      textStyle: TextStyle(fontSize: 30, color: currentColorScheme.textPrimary),
    );
  }

  TextStyle get navigationLabelStyle {
    return GoogleFonts.lato(
      textStyle: TextStyle(fontSize: 12, color: currentColorScheme.textPrimary),
    );
  }
}
