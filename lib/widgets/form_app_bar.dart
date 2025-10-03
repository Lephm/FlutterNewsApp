import 'package:centranews/models/custom_theme.dart';
import 'package:flutter/material.dart';

AppBar getFormAppBar(BuildContext context, CustomTheme currentTheme) {
  return AppBar(
    backgroundColor: currentTheme.currentColorScheme.bgPrimary,
    leading: BackButton(
      onPressed: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
      color: currentTheme.currentColorScheme.bgInverse,
    ),
  );
}
