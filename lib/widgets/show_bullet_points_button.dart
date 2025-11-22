import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/custom_theme.dart';
import '../providers/theme_provider.dart';
import '../utils/format_string_helper.dart';

class ShowBulletPointsButton extends ConsumerWidget {
  const ShowBulletPointsButton({
    super.key,
    this.size,
    required this.bulletPoints,
  });

  final double? size;
  final String bulletPoints;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentTheme = ref.watch(themeProvider);
    return (TextButton(
      onPressed: () {
        showBulletPoints(context, currentTheme);
      },
      child: Icon(
        Icons.format_list_bulleted,
        color: currentTheme.currentColorScheme.bgInverse,
        size: size,
      ),
    ));
  }

  void showBulletPoints(BuildContext context, CustomTheme currentTheme) {
    String formattedBulletPoints = formatBulletsPoints(bulletPoints);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          constraints: BoxConstraints(maxHeight: 600, maxWidth: 300),
          scrollable: true,
          iconPadding: EdgeInsetsGeometry.fromLTRB(10, 10, 10, 0),
          icon: Align(
            alignment: Alignment.centerLeft,
            child: BackButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: currentTheme.currentColorScheme.bgInverse,
            ),
          ),
          backgroundColor: currentTheme.currentColorScheme.bgPrimary,
          content: Text(
            formattedBulletPoints,
            style: currentTheme.textTheme.bodyMedium,
          ),
        );
      },
    );
  }
}
