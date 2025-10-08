import 'package:centranews/pages/bookmarks_page.dart';
import 'package:centranews/pages/discover_page.dart';
import 'package:centranews/pages/news_page.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/widgets/custom_home_navigation_bar.dart';
import 'package:centranews/widgets/home_app_bar.dart';
import 'package:centranews/widgets/home_drawer.dart';
import 'package:centranews/widgets/home_end_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int currentPageIndex = 0;
  final List<Widget> _pages = [
    const NewsPage(),
    const DiscoverPage(),
    const BookmarksPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: HomeAppBar(),
        drawer: HomeDrawer(),
        endDrawer: HomeEndDrawer(),
        body: IndexedStack(index: currentPageIndex, children: _pages),
        bottomNavigationBar: CustomHomeNavigationBar(
          setCurrentPageIndex: setCurrentPageIndex,
          currentPageIndex: currentPageIndex,
        ),
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,
      ),
    );
  }

  void setCurrentPageIndex(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }
}
