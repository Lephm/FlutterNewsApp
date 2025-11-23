import 'package:centranews/models/local_user.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/custom_navigator_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/pop_up_message.dart';

final supabase = Supabase.instance.client;

final userProvider = NotifierProvider<UserNotifier, LocalUser?>(
  () => UserNotifier(),
);

class UserNotifier extends Notifier<LocalUser?> {
  UserNotifier() {
    supabase.auth.onAuthStateChange.listen((data) async {
      debugPrint("Auth Change Event Happens");
      if (supabase.auth.currentUser == null) {
        setLocalUser(null);
      } else {
        debugPrint("User Logged In");
        setLocalUser(
          LocalUser(
            supabase.auth.currentUser!.id,
            [],
            supabase.auth.currentUser!.email ?? "User",
          ),
        );
      }
    });
  }

  void goToHomePage() {
    if (CustomNavigatorSettings.navigatorKey.currentState!.mounted) {
      CustomNavigatorSettings.navigatorKey.currentState?.pushNamed("/");
    }
  }

  final _auth = supabase.auth;
  Route<Object?>? _progressBarRoute;

  @override
  LocalUser? build() {
    LocalUser? initialValue;
    return initialValue;
  }

  void createAccountWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    var currentTheme = ref.watch(themeProvider);
    try {
      showProgressBar(context);
      await _auth.signUp(email: email, password: password);
      await _auth.signInWithPassword(email: email, password: password);
      goToHomePage();
    } catch (e) {
      if (context.mounted) {
        showAlertMessage(context, e.toString(), currentTheme);
      }
    } finally {
      closeProgressBar();
    }
  }

  void signInWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    var currentTheme = ref.watch(themeProvider);
    showProgressBar(context);
    try {
      await _auth.signInWithPassword(email: email, password: password);
      goToHomePage();
    } catch (e) {
      if (context.mounted) {
        showAlertMessage(context, e.toString(), currentTheme);
      }
    } finally {
      closeProgressBar();
    }
  }

  void signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void showProgressBar(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    _progressBarRoute = DialogRoute(
      context: context,
      builder: (context) => Center(
        heightFactor: 0.5,
        widthFactor: 0.5,
        child: CircularProgressIndicator(
          color: currentTheme.currentColorScheme.bgInverse,
          backgroundColor: currentTheme.currentColorScheme.bgPrimary,
        ),
      ),
    );
    try {
      CustomNavigatorSettings.navigatorKey.currentState!.push(
        _progressBarRoute as DialogRoute<Object?>,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void closeProgressBar() {
    try {
      if (_progressBarRoute != null) {
        CustomNavigatorSettings.navigatorKey.currentState?.removeRoute(
          _progressBarRoute as Route<Object?>,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    _progressBarRoute = null;
  }

  void setLocalUser(LocalUser? user) {
    state = user;
  }
}
