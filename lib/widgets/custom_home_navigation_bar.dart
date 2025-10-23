import 'package:centranews/models/language_localization.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/localization_provider.dart';

const double navigationBarIconSize = 20;

class CustomHomeNavigationBar extends ConsumerStatefulWidget {
  const CustomHomeNavigationBar({
    super.key,
    required this.setCurrentPageIndex,
    required this.currentPageIndex,
  });

  final void Function(int index) setCurrentPageIndex;
  final int currentPageIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomHomeNavigationBarState();
}

class _CustomHomeNavigationBarState
    extends ConsumerState<CustomHomeNavigationBar> {
  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(maxHeight: 60),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.all(
              currentTheme.textTheme.navigationLabelStyle,
            ),
          ),
          child: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                widget.setCurrentPageIndex(index);
              });
            },
            selectedIndex: widget.currentPageIndex,
            destinations: navigatorIcons(localization),
            backgroundColor: Colors.transparent,
            indicatorColor: currentTheme.currentColorScheme.bgSecondary,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          ),
        ),
      ),
    );
  }

  List<Widget> navigatorIcons(LanguageLocalizationTexts localization) {
    var currentTheme = ref.watch(themeProvider);
    return [
      NavigationDestination(
        selectedIcon: Icon(
          Icons.article,
          color: currentTheme.currentColorScheme.bgInverse,
          size: navigationBarIconSize,
        ),
        icon: Icon(
          Icons.article_outlined,
          color: currentTheme.currentColorScheme.bgInverse,
          size: navigationBarIconSize,
        ),
        label: localization.news,
      ),
      NavigationDestination(
        icon: Icon(
          Icons.explore,
          color: currentTheme.currentColorScheme.bgInverse,
          size: navigationBarIconSize,
        ),
        label: localization.discovery,
      ),
      NavigationDestination(
        icon: Icon(
          Icons.bookmark_border,
          color: currentTheme.currentColorScheme.bgInverse,
          size: navigationBarIconSize,
        ),
        selectedIcon: Icon(
          Icons.bookmarks,
          color: currentTheme.currentColorScheme.bgInverse,
          size: navigationBarIconSize,
        ),
        label: localization.bookmarks,
      ),
    ];
  }
}
