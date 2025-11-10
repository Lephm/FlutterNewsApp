import 'package:centranews/models/custom_color_scheme.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextTheme {
  CustomTextTheme({required this.currentColorScheme});

  CustomColorScheme currentColorScheme;

  TextStyle get bodyMedium {
    return GoogleFonts.rubik(
      textStyle: TextStyle(color: currentColorScheme.textPrimary),
    );
  }

  TextStyle get bodyLightMedium {
    return GoogleFonts.rubik(
      textStyle: TextStyle(color: currentColorScheme.textSecondary),
    );
  }

  TextStyle get bodyMediumBold {
    return GoogleFonts.rubik(
      textStyle: TextStyle(
        color: currentColorScheme.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextStyle get bodyInverseMedium {
    return GoogleFonts.rubik(
      textStyle: TextStyle(color: currentColorScheme.textInverse),
    );
  }

  TextStyle get bodyLarge {
    return GoogleFonts.rubik(textStyle: TextStyle());
  }

  TextStyle get bodySmall {
    return GoogleFonts.rubik(
      textStyle: TextStyle(fontSize: 15, color: currentColorScheme.textPrimary),
    );
  }

  TextStyle get smallLabelBold {
    return GoogleFonts.rubik(
      textStyle: TextStyle(
        fontSize: 10,
        color: currentColorScheme.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextStyle get smallLabelBoldInverse {
    return GoogleFonts.rubik(
      textStyle: TextStyle(
        fontSize: 10,
        color: currentColorScheme.textInverse,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextStyle get categoryTextBoldInverse {
    return GoogleFonts.rubik(
      textStyle: TextStyle(
        fontSize: 11,
        color: currentColorScheme.textInverse,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextStyle get bodyBold {
    return GoogleFonts.rubik(
      textStyle: TextStyle(
        fontSize: 15,
        color: currentColorScheme.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextStyle get headlineMedium {
    return GoogleFonts.rubik(
      textStyle: TextStyle(fontSize: 30, color: currentColorScheme.textPrimary),
    );
  }

  TextStyle get appBarLogoStyle {
    return GoogleFonts.rubik(
      textStyle: TextStyle(fontSize: 20, color: currentColorScheme.textPrimary),
    );
  }

  TextStyle get hyperlinkSourceStyle {
    return GoogleFonts.rubik(
      textStyle: TextStyle(fontSize: 15, color: currentColorScheme.textPrimary),
    );
  }

  TextStyle get navigationLabelStyle {
    return GoogleFonts.rubik(
      textStyle: TextStyle(fontSize: 12, color: currentColorScheme.textPrimary),
    );
  }
}
