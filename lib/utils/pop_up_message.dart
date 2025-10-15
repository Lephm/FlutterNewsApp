import 'package:flutter/cupertino.dart';
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

      title: BackButton(style: ButtonStyle(alignment: Alignment(-1.0, -1.0))),
      content: Text(content, style: currentTheme.textTheme.bodyMedium),
    ),
  );
}
