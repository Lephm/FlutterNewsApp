import 'package:centranews/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentTheme = ref.watch(themeProvider);
    return AppBar(
      backgroundColor: currentTheme.currentColorScheme.bgPrimary,
      shape: Border(
        bottom: BorderSide(color: currentTheme.currentColorScheme.bgInverse),
      ),
      leading: drawerIcon(context),
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

  Widget drawerIcon(BuildContext context) {
    return IconButton(
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      icon: Icon(Icons.subject),
    );
  }
}
