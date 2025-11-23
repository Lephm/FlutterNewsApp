import 'package:centranews/providers/local_user_provider.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/validationhelper.dart';
import 'package:centranews/widgets/custom_checkbox.dart';
import 'package:centranews/widgets/custom_form_button.dart';
import 'package:centranews/widgets/custom_safe_area.dart';
import 'package:centranews/widgets/custom_textformfield.dart';
import 'package:centranews/widgets/form_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final GlobalKey<FormState> _signInFormKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obsecureText = true;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return CustomSafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: FormAppBar(
          onBackButtonPressed: () {
            Navigator.of(context).pushNamed("/");
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
            child: SizedBox(
              width: double.infinity,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  appIntroWidget(),
                  signInForm(),
                  rememberMeAndForgotPasswordRow(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/sign_up");
                      },
                      child: Text(
                        localization.dontHaveAnAccountSignUpHere,
                        style: TextStyle(
                          color: currentTheme.currentColorScheme.textSecondary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,
      ),
    );
  }

  Widget appIntroWidget() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return Column(
      children: [
        SizedBox(height: 80),
        Image(
          image: AssetImage("assets/app_icon.png"),
          height: 150,
          color: currentTheme.currentColorScheme.bgInverse,
        ),
        SizedBox(height: 10),
        Text(
          localization.welcome,
          style: currentTheme.textTheme.headlineMedium,
        ),
        Text(
          localization.signInToYourAccount,
          style: currentTheme.textTheme.bodyLightMedium,
        ),
      ],
    );
  }

  Widget rememberMeAndForgotPasswordRow() {
    var localization = ref.watch(localizationProvider);
    var currentTheme = ref.watch(themeProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                CustomCheckBox(
                  isCheckboxOn: rememberMe,
                  onChanged: setRememberMe,
                ),
                Text(
                  localization.rememberMe,
                  style: currentTheme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/reset_password_prompt");
            },
            child: Text(
              localization.forgotPassword,
              style: TextStyle(
                color: currentTheme.currentColorScheme.textSecondary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInForm() {
    var localization = ref.watch(localizationProvider);
    var userManager = ref.watch(userProvider.notifier);
    return Form(
      key: _signInFormKey,
      child: Column(
        children: [
          CustomTextFormField(
            hintText: localization.enterYourEmail,
            controller: emailController,
            validatorFunc: (value) {
              return isEmailValid(value, localization);
            },
          ),
          CustomTextFormField(
            hintText: localization.enterYourPassword,
            controller: passwordController,
            validatorFunc: (value) {
              return isPasswordValid(value, localization);
            },
            obscureText: obsecureText,
            suffixIcon: displayPasswordVisibilityIcon(),
          ),
          CustomFormButton(
            onPressed: () {
              if (_signInFormKey.currentState!.validate()) {
                userManager.signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text,
                  context: context,
                );
              }
            },
            content: localization.signIn,
          ),
        ],
      ),
    );
  }

  IconButton displayPasswordVisibilityIcon() {
    return IconButton(
      onPressed: () {
        switchObsecureText();
      },
      icon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        child: Icon(obsecureText ? Icons.visibility : Icons.visibility_off),
      ),
    );
  }

  void switchObsecureText() {
    setState(() {
      obsecureText = !obsecureText;
    });
  }

  void setRememberMe(bool? value) {
    if (value != null) {
      setState(() {
        rememberMe = value;
      });
    }
  }
}
