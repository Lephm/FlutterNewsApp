import 'package:centranews/models/custom_theme.dart';
import 'package:centranews/models/local_user.dart';
import 'package:centranews/providers/local_user_provider.dart';
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
    var localUser = ref.watch(userProvider);
    UserNotifier userNotifier = ref.watch(userProvider.notifier);
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Settings", style: currentTheme.textTheme.headlineMedium),
            Text(
              localUser == null
                  ? "You're not logged in"
                  : localUser.emailAdress,
            ),
            displaySignInOptions(
              context: context,
              currentTheme: currentTheme,
              localUser: localUser,
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
  }) {
    return localUser == null
        ? displaySignInButton(context)
        : displaySignOutButton(context, userNotifier);
  }

  Widget displaySignInButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed("/sign_in");
      },
      child: Text("Sign In"),
    );
  }

  Widget displaySignOutButton(BuildContext context, UserNotifier userNotifier) {
    return TextButton(
      onPressed: () async {
        try {
          userNotifier.signOut();
          userNotifier.showAlertMessage(
            context,
            "You have sucessfully Signed Out",
          );
        } catch (e) {
          userNotifier.showAlertMessage(context, e.toString());
        }
      },
      child: Text("Sign Out"),
    );
  }
}
