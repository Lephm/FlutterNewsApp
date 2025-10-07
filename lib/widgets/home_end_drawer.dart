import 'package:centranews/models/custom_theme.dart';
import 'package:centranews/models/language_localization.dart';
import 'package:centranews/models/local_user.dart';
import 'package:centranews/providers/local_user_provider.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Settings", style: currentTheme.textTheme.headlineMedium),
            Text(
              localUser == null
                  ? localization.youreNotLoggedIn
                  : localUser.emailAdress,
            ),
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
    );
  }

  Widget displaySignInOptions({
    required BuildContext context,
    required CustomTheme currentTheme,
    required LocalUser? localUser,
    required UserNotifier userNotifier,
    required LanguageLocalizationTexts localization
  }) {
    return localUser == null
        ? displaySignInButton(context,localization)
        : displaySignOutButton(context, localization,userNotifier);
  }

  Widget displaySignInButton(BuildContext context, LanguageLocalizationTexts localization) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed("/sign_in");
      },
      child: Text(localization.signIn),
    );
  }

  Widget displaySignOutButton(BuildContext context, LanguageLocalizationTexts localization, UserNotifier userNotifier) {
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
      child: Text(localization.signOut),
    );
  }
}
