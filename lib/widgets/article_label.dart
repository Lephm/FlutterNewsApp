import 'package:centranews/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArticleLabel extends ConsumerWidget {
  const ArticleLabel({
    super.key,
    this.inversed = false,
    required this.content,
    this.leadingIcon,
  });

  final bool inversed;
  final String content;
  final Icon? leadingIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentTheme = ref.watch(themeProvider);
    var bgColor = currentTheme.currentColorScheme.bgPrimary;
    var labelTextStyle = currentTheme.textTheme.smallLabelBold;
    var borderColor = currentTheme.currentColorScheme.bgInverse;
    if (inversed) {
      bgColor = currentTheme.currentColorScheme.bgInverse;
      labelTextStyle = currentTheme.textTheme.smallLabelBoldInverse;
    }
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
        border: BoxBorder.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leadingIcon != null) ...[leadingIcon!, const SizedBox(width: 5)],
          Text(content, style: labelTextStyle),
        ],
      ),
    );
  }
}
