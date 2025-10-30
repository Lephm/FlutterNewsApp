import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/custom_theme.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    required this.headerText,
    required this.currentPageIndex,
  });

  final String headerText;
  final int currentPageIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentTheme = ref.watch(themeProvider);
    return AppBar(
      forceMaterialTransparency: true,
      backgroundColor: currentTheme.currentColorScheme.bgPrimary,
      leading: (isNewsPage())
          ? drawerIcon(context, currentTheme)
          : SizedBox.shrink(),
      title: Center(
        child: (isNewsPage())
            ? CustomSearchBar()
            : Text(
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
              icon: Icon(
                Icons.account_circle,
                size: 30,
                color: currentTheme.currentColorScheme.bgSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  bool isNewsPage() {
    return currentPageIndex == 0;
  }

  Widget drawerIcon(BuildContext context, CustomTheme currentTheme) {
    return IconButton(
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      icon: Icon(
        Icons.filter_alt,
        size: 24,
        color: currentTheme.currentColorScheme.bgSecondary,
      ),
    );
  }
}
