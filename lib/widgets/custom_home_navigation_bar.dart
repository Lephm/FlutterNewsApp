import 'package:centranews/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          widget.setCurrentPageIndex(index);
        });
      },
      selectedIndex: widget.currentPageIndex,
      destinations: navigatorIcons(),
      backgroundColor: currentTheme.currentColorScheme.bgPrimary,
      indicatorColor: currentTheme.currentColorScheme.bgSecondary,
    );
  }

  List<Widget> navigatorIcons() {
    return [
      NavigationDestination(
        selectedIcon: Icon(Icons.article_outlined),
        icon: Icon(Icons.article),
        label: 'Home',
      ),
      NavigationDestination(icon: Icon(Icons.explore), label: 'Notifications'),
      NavigationDestination(
        icon: Icon(Icons.bookmark),
        selectedIcon: Icon(Icons.bookmark_border_outlined),
        label: 'Bookmarks',
      ),
    ];
  }
}
