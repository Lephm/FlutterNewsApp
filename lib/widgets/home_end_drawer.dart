import 'package:centranews/models/custom_theme.dart';
import 'package:centranews/providers/local_user_provider.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/widgets/custom_container.dart';
import 'package:centranews/widgets/home_button_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localstorage/localstorage.dart';

import '../utils/pop_up_message.dart';

class HomeEndDrawer extends ConsumerStatefulWidget {
  const HomeEndDrawer({super.key});

  @override
  ConsumerState<HomeEndDrawer> createState() => _HomeEndDrawerState();
}

class _HomeEndDrawerState extends ConsumerState<HomeEndDrawer> {
  String? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    var localUser = ref.watch(userProvider);
    if (context.mounted) {
      loadInitialLanguageSetting();
    }
    return Drawer(
      backgroundColor: currentTheme.currentColorScheme.bgPrimary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              localization.settings,
              style: currentTheme.textTheme.headlineMedium,
            ),
            Text(
              localUser == null
                  ? localization.youreNotLoggedIn
                  : localUser.emailAdress,
              style: currentTheme.textTheme.bodyLightMedium,
            ),
            SizedBox(height: 30),
            CustomContainer(
              child: Column(
                children: [displaySignInOptions(), changeLanguageOptions()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget displaySignInOptions() {
    var localUser = ref.watch(userProvider);
    return localUser == null ? displaySignInButton() : displaySignOutButton();
  }

  Widget displaySignInButton() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed("/sign_in");
      },
      child: HomeButtonContainer(
        children: [
          customCircleAvatar(
            Icon(Icons.login, color: currentTheme.currentColorScheme.bgInverse),
            currentTheme,
          ),
          Text(localization.signIn, style: currentTheme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget displaySignOutButton() {
    var localization = ref.watch(localizationProvider);
    var userNotifier = ref.watch(userProvider.notifier);
    var currentTheme = ref.watch(themeProvider);
    return TextButton(
      onPressed: () async {
        try {
          userNotifier.signOut();
          showAlertMessage(
            context,
            localization.youHaveSucessfullySignedOut,
            currentTheme,
          );
        } catch (e) {
          showAlertMessage(context, e.toString(), currentTheme);
        }
      },
      child: HomeButtonContainer(
        children: [
          customCircleAvatar(
            Icon(
              Icons.logout,
              color: currentTheme.currentColorScheme.bgInverse,
            ),
            currentTheme,
          ),
          Text(localization.signOut, style: currentTheme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget customCircleAvatar(Widget child, CustomTheme currentTheme) {
    return CircleAvatar(
      radius: 15,
      backgroundColor: currentTheme.currentColorScheme.bgSecondary,
      child: child,
    );
  }

  void loadInitialLanguageSetting() {
    var localLangPreference = localStorage.getItem("language");
    if (selectedLanguage == null) {
      setState(() {
        selectedLanguage = localLangPreference ?? "vn";
      });
    }
  }

  Widget changeLanguageOptions() {
    var currentTheme = ref.watch(themeProvider);
    var localizationManager = ref.watch(localizationProvider.notifier);
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        dropdownColor: currentTheme.currentColorScheme.bgPrimary,
        value: selectedLanguage,
        items: <DropdownMenuItem<String>>[
          DropdownMenuItem(
            value: 'vn',
            child: Text(
              "Vietnamese",
              style: currentTheme.textTheme.bodyLightMedium,
            ),
          ),
          DropdownMenuItem(
            value: 'en',
            child: Text(
              "English",
              style: currentTheme.textTheme.bodyLightMedium,
            ),
          ),
        ],
        onChanged: (String? newValue) {
          setState(() {
            selectedLanguage = newValue;
          });
          if (newValue == "en") {
            localStorage.setItem('language', "en");
            localizationManager.changeLanguageToEnglish();
            Navigator.of(context).pushReplacementNamed("/");
          }
          if (newValue == "vn") {
            localStorage.setItem('language', "vn");
            localizationManager.changeLanguageToVietnamese();
            Navigator.of(context).pushReplacementNamed("/");
          }
        },
        elevation: 16,
      ),
    );
  }
}
