import 'package:centranews/models/custom_theme.dart';
import 'package:centranews/models/local_user.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = NotifierProvider<UserNotifier, LocalUser?>(
  () => UserNotifier(),
);

class UserNotifier extends Notifier<LocalUser?> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      _showAlertMessage(
        context,
        "There was something wrong when creating an account, Please try again later",
      );
    }
  }

  void signInWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      _showAlertMessage(
        context,
        "There was an error when you tried to log is. Please Try Again Later",
      );
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

  //   void signInWithFacebook() async{}
  //   void signInWithTwitter() async{}
  //   void signInWith() async{}
  //
}
