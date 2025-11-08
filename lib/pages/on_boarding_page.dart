import 'package:centranews/widgets/custom_form_button.dart';
import 'package:centranews/widgets/custom_form_button_outline_style.dart';
import 'package:centranews/widgets/custom_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localstorage/localstorage.dart';

import '../providers/localization_provider.dart';
import '../providers/theme_provider.dart';

class OnBoardingPage extends ConsumerStatefulWidget {
  const OnBoardingPage({super.key});

  @override
  ConsumerState<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends ConsumerState<OnBoardingPage> {
  int currentPageIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    return CustomSafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,
        body: PageView(
          controller: _pageController,
          children: <Widget>[introductionPage(), finalPage()],
        ),
      ),
    );
  }

  void saveHasLoadedOnBoardingPage() {
    localStorage.setItem("hasLoadedOnboarding", "true");
  }

  Widget introductionPage() {
    var localization = ref.watch(localizationProvider);
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            appIntroWidget(),
            Container(
              constraints: BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.symmetric(horizontal: 9.0),
              child: CustomFormButton(
                onPressed: () {
                  saveHasLoadedOnBoardingPage();
                  setState(() {
                    currentPageIndex = 1;
                  });
                  if (_pageController.hasClients) {
                    _pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                content: localization.gettingStarted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appIntroWidget() {
    var currentTheme = ref.watch(themeProvider);
    return Center(
      child: Column(
        children: [
          Image(
            image: AssetImage("assets/app_logo.png"),
            height: 300,
            color: currentTheme.currentColorScheme.bgInverse,
          ),
        ],
      ),
    );
  }

  Widget finalPage() {
    var localization = ref.watch(localizationProvider);
    return Center(
      child: SingleChildScrollView(
        child: Column(
          spacing: 30,
          children: [
            appIntroWidget(),
            Container(
              constraints: BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.symmetric(horizontal: 9.0),
              child: CustomFormButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/sign_up");
                },
                content: localization.signUp,
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.symmetric(horizontal: 9.0),
              child: CustomFormButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/sign_in");
                },
                content: localization.signIn,
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.symmetric(horizontal: 9.0),
              child: CustomFormButtonOutlineStyle(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed("/");
                },
                content: localization.skip,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
