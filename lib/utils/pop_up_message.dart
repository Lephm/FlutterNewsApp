import 'package:centranews/models/language_localization.dart';
import 'package:flutter/material.dart';

import '../models/custom_theme.dart';

void showAlertMessage(
  BuildContext context,
  String content,
  CustomTheme currentTheme,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: currentTheme.currentColorScheme.bgPrimary,

      title: BackButton(
        color: currentTheme.currentColorScheme.bgInverse,
        style: ButtonStyle(alignment: Alignment(-1.0, -1.0)),
      ),
      content: Text(content, style: currentTheme.textTheme.bodyMedium),
    ),
  );
}

void showSignInPrompt(
  BuildContext context,
  CustomTheme currentTheme,
  LanguageLocalizationTexts localization,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: currentTheme.currentColorScheme.bgPrimary,

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(
            color: currentTheme.currentColorScheme.bgInverse,
            style: ButtonStyle(alignment: Alignment(-1.0, -1.0)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/sign_in");
            },
            child: Text(
              localization.signIn,
              style: currentTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
      content: Text(
        localization.youMustSignInPrompt,
        style: currentTheme.textTheme.bodyMedium,
      ),
    ),
  );
}
