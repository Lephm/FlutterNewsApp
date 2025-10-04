import 'package:centranews/models/custom_theme.dart';
import 'package:centranews/models/local_user.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final userProvider = NotifierProvider<UserNotifier, LocalUser?>(
  () => UserNotifier(),
);

class UserNotifier extends Notifier<LocalUser?> {
  final _auth = supabase.auth;
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
    try {
      await _auth.signUp(email: email, password: password);
    } catch (e) {
      if (context.mounted) {
        _showAlertMessage(
          context,
          "There was something wrong when creating an account, Please try again later",
        );
      }
    }
  }

  void signInWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      if (context.mounted) {
        _showAlertMessage(
          context,
          "There was an error when you tried to log is. Please Try Again Later",
        );
      }
    }
  }

  void signOut() async {
    return _auth.signOut();
  }

  void _showAlertMessage(BuildContext context, String content) {
    CustomTheme currentTheme = ref.watch(themeProvider);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,

        title: BackButton(style: ButtonStyle(alignment: Alignment(-1.0, -1.0))),
        content: Text(content),
      ),
    );
  }

  void signInWithGoogle(BuildContext context) async {
    if (kIsWeb) {
      try {
        await supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          redirectTo:
              'https://abugihnaowqdwntoervn.supabase.co/auth/v1/callback',
        );
      } catch (e) {
        if (context.mounted) {
          _showAlertMessage(
            context,
            "Something Went Wrong when you tried to log in",
          );
        }
      }
      return;
    }
    const webClientId =
        '459545354997-il8rqbl88n9i53k1ouua0qk2c8s3o9r5.apps.googleusercontent.com';

    const iosClientId = 'my-ios.apps.googleusercontent.com';

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
        _showAlertMessage(context, e.toString());
      }
    }
  }

  //TODO: implement progress bar
  void showProgressBar(CustomTheme currentTheme) {}

  // TODO: implement set local user
  void setLocalUser(LocalUser? user) {
    state = user;
  }
}
