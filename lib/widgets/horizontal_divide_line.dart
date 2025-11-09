import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_provider.dart';

class HorizontalDivideLine extends ConsumerWidget {
  const HorizontalDivideLine({
    super.key,
    required this.height,
    required this.horizontalMargin,
  });

  final height;
  final horizontalMargin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentTheme = ref.watch(themeProvider);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      color: currentTheme.currentColorScheme.bgInverse,
      width: double.infinity,
      height: height,
    );
  }
}
