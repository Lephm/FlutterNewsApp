import 'package:centranews/models/app_info.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const double iconSize = 30;

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
      leadingWidth: double.infinity,
      leading: isNewsPage()
          ? appIcon(ref)
          : Center(
              child: Text(
                headerText,
                style: currentTheme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),

      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            (isNewsPage() ? searchIcon(ref, context) : SizedBox.shrink()),
            (isNewsPage() ? filterIcon(ref, context) : SizedBox.shrink()),
            settingIconButton(context, ref),
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

  Widget searchIcon(WidgetRef ref, BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed("/search_articles");
      },
      icon: Icon(
        Icons.search,
        size: iconSize,
        color: currentTheme.currentColorScheme.bgInverse,
      ),
    );
  }

  Widget settingIconButton(BuildContext context, WidgetRef ref) {
    var currentTheme = ref.watch(themeProvider);
    return IconButton(
      onPressed: () {
        Scaffold.of(context).openEndDrawer();
      },
      icon: Icon(
        Icons.account_circle,
        size: iconSize,
        color: currentTheme.currentColorScheme.bgInverse,
      ),
    );
  }

  Widget appIcon(WidgetRef ref) {
    var currentTheme = ref.watch(themeProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5,
        children: [
          Flexible(
            child: Image(image: AssetImage("assets/app_icon.png"), height: 30),
          ),
          Flexible(
            child: Text(
              AppInfo.title,
              style: currentTheme.textTheme.headlineMedium,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  Widget filterIcon(WidgetRef ref, BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    return IconButton(
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      icon: Icon(
        Icons.filter_alt,
        size: iconSize,
        color: currentTheme.currentColorScheme.bgInverse,
      ),
    );
  }
}
