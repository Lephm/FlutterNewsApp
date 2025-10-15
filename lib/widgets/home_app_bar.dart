import 'package:centranews/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/custom_theme.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, required this.headerText});

  final String headerText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentTheme = ref.watch(themeProvider);
    return AppBar(
      backgroundColor: currentTheme.currentColorScheme.bgPrimary,
      shape: Border(
        bottom: BorderSide(color: currentTheme.currentColorScheme.bgInverse),
      ),
      leading: drawerIcon(context, currentTheme),
      title: Center(
        child: Text(
          headerText,
          style: currentTheme.textTheme.headlineMedium,
          textAlign: TextAlign.start,
        ),
      ),
      actions: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: Icon(Icons.account_circle),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget drawerIcon(BuildContext context, CustomTheme currentTheme) {
    return IconButton(
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      icon: Icon(
        Icons.filter_alt,
        size: 24,
        color: currentTheme.currentColorScheme.bgInverse.withAlpha(180),
      ),
    );
  }
}
