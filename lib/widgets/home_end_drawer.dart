import 'package:centranews/models/custom_theme.dart';
import 'package:centranews/models/language_localization.dart';
import 'package:centranews/models/local_user.dart';
import 'package:centranews/providers/local_user_provider.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/widgets/custom_container.dart';
import 'package:centranews/widgets/home_button_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeEndDrawer extends ConsumerStatefulWidget {
  const HomeEndDrawer({super.key});

  @override
  ConsumerState<HomeEndDrawer> createState() => _HomeEndDrawerState();
}

class _HomeEndDrawerState extends ConsumerState<HomeEndDrawer> {
  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    var localUser = ref.watch(userProvider);
    UserNotifier userNotifier = ref.watch(userProvider.notifier);
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
                children: [
                  displaySignInOptions(
                    context: context,
                    currentTheme: currentTheme,
                    localUser: localUser,
                    localization: localization,
                    userNotifier: userNotifier,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget displaySignInOptions({
    required BuildContext context,
    required CustomTheme currentTheme,
    required LocalUser? localUser,
    required UserNotifier userNotifier,
    required LanguageLocalizationTexts localization,
  }) {
    return localUser == null
        ? displaySignInButton(context, localization, currentTheme)
        : displaySignOutButton(
            context,
            localization,
            userNotifier,
            currentTheme,
          );
  }

  Widget displaySignInButton(
    BuildContext context,
    LanguageLocalizationTexts localization,
    CustomTheme currentTheme,
  ) {
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

  Widget displaySignOutButton(
    BuildContext context,
    LanguageLocalizationTexts localization,
    UserNotifier userNotifier,
    CustomTheme currentTheme,
  ) {
    return TextButton(
      onPressed: () async {
        try {
          userNotifier.signOut();
          userNotifier.showAlertMessage(
            context,
            localization.youHaveSucessfullySignedOut,
          );
        } catch (e) {
          userNotifier.showAlertMessage(context, e.toString());
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
          Text(localization.signOut),
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
}
