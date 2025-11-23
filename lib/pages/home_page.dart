import 'package:centranews/models/app_info.dart';
import 'package:centranews/models/language_localization.dart';
import 'package:centranews/pages/bookmarks_page.dart';
import 'package:centranews/pages/for_you_page.dart';
import 'package:centranews/pages/news_page.dart';
import 'package:centranews/pages/on_boarding_page.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/widgets/banner_ad_container.dart';
import 'package:centranews/widgets/custom_home_navigation_bar.dart';
import 'package:centranews/widgets/custom_safe_area.dart';
import 'package:centranews/widgets/home_app_bar.dart';
import 'package:centranews/widgets/home_drawer.dart';
import 'package:centranews/widgets/home_end_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localstorage/localstorage.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int currentPageIndex = 0;
  bool hasLoadedOnboardingState = false;
  bool isLoadingOnbardingState = true;
  final List<Widget> _pages = [
    const NewsPage(),
    const ForYouPage(),
    const BookmarksPage(),
  ];
  String currentPageHeaderText = "";

  @override
  Widget build(BuildContext context) {
    if (dontNeedToShowOnBoardingPage()) {
      return displayHomePage();
    } else {
      loadOnboardingStateFromLocalStorage();
      return isLoadingOnbardingState
          ? circularProgressBarPage()
          : hasLoadedOnboardingState
          ? displayHomePage()
          : OnBoardingPage();
    }
  }

  bool dontNeedToShowOnBoardingPage() {
    // TODO: currently showing onboarding on web for testingreturn kIsWeb;
    return false;
  }

  Widget displayHomePage() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    if (currentPageHeaderText == "") {
      currentPageHeaderText = AppInfo.title;
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

  void loadOnboardingStateFromLocalStorage() {
    if (hasLoadedOnboardingState) {
      return;
    }
    var hasLoadedOnboarding = localStorage.getItem("hasLoadedOnboarding");
    if (!mounted) {
      return;
    }
    if (hasLoadedOnboarding == null || hasLoadedOnboarding == "false") {
      setState(() {
        hasLoadedOnboardingState = false;
      });
    } else {
      setState(() {
        hasLoadedOnboardingState = true;
      });
    }
    setState(() {
      isLoadingOnbardingState = false;
    });
  }

  void setPageHeader(int index, LanguageLocalizationTexts localization) {
    String newHeaderText = "";
    switch (currentPageIndex) {
      case 0:
        newHeaderText = AppInfo.title;
        break;
      case 1:
        newHeaderText = localization.forYou;
        break;
      case 2:
        newHeaderText = localization.bookmarks;
        break;
      default:
        newHeaderText = AppInfo.title;
    }
    setState(() {
      currentPageHeaderText = newHeaderText;
    });
  }

  Widget circularProgressBarPage() {
    var currentTheme = ref.watch(themeProvider);
    return Scaffold(
      backgroundColor: currentTheme.currentColorScheme.bgPrimary,
      body: Center(
        child: CircularProgressIndicator(
          color: currentTheme.currentColorScheme.bgInverse,
          backgroundColor: currentTheme.currentColorScheme.bgPrimary,
        ),
      ),
    );
  }
}
