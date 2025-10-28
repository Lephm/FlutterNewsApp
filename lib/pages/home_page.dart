import 'package:centranews/models/language_localization.dart';
import 'package:centranews/pages/bookmarks_page.dart';
import 'package:centranews/pages/discover_page.dart';
import 'package:centranews/pages/news_page.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/widgets/banner_ad_container.dart';
import 'package:centranews/widgets/custom_home_navigation_bar.dart';
import 'package:centranews/widgets/custom_safe_area.dart';
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
  String currentPageHeaderText = "";

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    if (currentPageHeaderText == "") {
      currentPageHeaderText = localization.news;
    }
    return CustomSafeArea(
      child: Scaffold(
        floatingActionButton: BannerAdContainer(),
        resizeToAvoidBottomInset: false,
        appBar: HomeAppBar(
          headerText: currentPageHeaderText,
          currentPageIndex: currentPageIndex,
        ),
        drawer: HomeDrawer(),
        endDrawer: HomeEndDrawer(),
        body: _pages[currentPageIndex],
        bottomNavigationBar: CustomHomeNavigationBar(
          setCurrentPageIndex: (index) {
            setCurrentPageIndex(index);
            setPageHeader(index, localization);
          },
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

  void setPageHeader(int index, LanguageLocalizationTexts localization) {
    String newHeaderText = "";
    switch (currentPageIndex) {
      case 0:
        newHeaderText = localization.news;
        break;
      case 1:
        newHeaderText = localization.discovery;
        break;
      case 2:
        newHeaderText = localization.bookmarks;
        break;
      default:
        newHeaderText = localization.news;
    }
    setState(() {
      currentPageHeaderText = newHeaderText;
    });
  }
}
