import 'package:centranews/widgets/custom_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localstorage/localstorage.dart';

import '../providers/theme_provider.dart';

class OnBoardingPage extends ConsumerStatefulWidget {
  const OnBoardingPage({super.key});

  @override
  ConsumerState<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends ConsumerState<OnBoardingPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    return CustomSafeArea(
      child: Scaffold(
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,
        body: currentPageIndex == 0 ? introductionPage() : finalPage(),
      ),
    );
  }

  void saveHasLoadedOnBoardingPage() {
    localStorage.setItem("hasLoadedOnboarding", "true");
  }

  Widget introductionPage() {
    return Center(
      child: TextButton(
        onPressed: () {
          setState(() {
            currentPageIndex = 1;
            saveHasLoadedOnBoardingPage();
          });
        },
        child: Text("Continue"),
      ),
    );
  }

  Widget finalPage() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed("/");
        },
        child: Text("Go to main page"),
      ),
    );
  }
}
