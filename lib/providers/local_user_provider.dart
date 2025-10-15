import 'package:centranews/models/local_user.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/custom_navigator_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
        if (CustomNavigatorSettings.navigatorKey.currentState!.mounted) {
          CustomNavigatorSettings.navigatorKey.currentState?.pushNamed("/");
        }
      }
    });
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
    var localization = ref.watch(localizationProvider);
    var currentTheme = ref.watch(themeProvider);
    try {
      await _auth.signUp(email: email, password: password);
      await _auth.signInWithPassword(email: email, password: password);
      if (context.mounted) {
        showAlertMessage(
          context,
          localization.signInSucessFullyMessage,
          currentTheme,
        );
      }
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
    var localization = ref.watch(localizationProvider);
    var currentTheme = ref.watch(themeProvider);
    try {
      showProgressBar(context);
      await _auth.signInWithPassword(email: email, password: password);
      if (context.mounted) {
        showAlertMessage(
          context,
          localization.signInSucessFullyMessage,
          currentTheme,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showAlertMessage(context, e.toString(), currentTheme);
      }
    } finally {
      closeProgressBar();
    }
  }

  void signOut() async {
    return _auth.signOut();
  }

  void signInWithGoogle(BuildContext context) async {
    var currentTheme = ref.watch(themeProvider);
    if (kIsWeb) {
      try {
        await supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo:
              'https://abugihnaowqdwntoervn.supabase.co/auth/v1/callback',
        );
      } catch (e) {
        if (context.mounted) {
          showAlertMessage(context, e.toString(), currentTheme);
        }
      } finally {
        closeProgressBar();
      }
      return;
    }
    const webClientId =
        '459545354997-il8rqbl88n9i53k1ouua0qk2c8s3o9r5.apps.googleusercontent.com';

    const iosClientId =
        '459545354997-4u3n1d1q1e9nhu3pp5jac0on5lcfqg5p.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    try {
      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      if (context.mounted) {
        showAlertMessage(context, e.toString(), currentTheme);
      }
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

  //TODO: fully implement signInWithTwitter
  void signInWithTwitter(BuildContext context) async {
    var currentTheme = ref.watch(themeProvider);
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.twitter,
        redirectTo:
            'https://abugihnaowqdwntoervn.supabase.co/auth/v1/callback', // Supabase deep link
      );
    } catch (e) {
      if (context.mounted) {
        showAlertMessage(context, e.toString(), currentTheme);
      }
    }
  }
}
