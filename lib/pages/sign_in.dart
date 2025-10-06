import 'package:centranews/models/custom_color_scheme.dart';
import 'package:centranews/models/custom_theme.dart';
import 'package:centranews/models/language_localization.dart';
import 'package:centranews/providers/local_user_provider.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/validationhelper.dart';
import 'package:centranews/widgets/custom_checkbox.dart';
import 'package:centranews/widgets/custom_form_button.dart';
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
    var userManager = ref.watch(userProvider.notifier);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: FormAppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
        child: SizedBox(
          width: double.infinity,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              appIntroWidget(localization, currentTheme),
              signInForm(currentTheme, context, localization, userManager),
              rememberMeAndForgotPasswordRow(currentTheme, localization),
              signInWithSocialMediaRow(localization, currentTheme),
              otherSignInMethodRow(currentTheme, userManager, context),
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
      backgroundColor: currentTheme.currentColorScheme.bgPrimary,
    );
  }

  Widget appIntroWidget(
    LanguageLocalizationTexts localization,
    CustomTheme currentTheme,
  ) {
    return Column(
      children: [
        Image(image: AssetImage("assets/blackcircle.png")),
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

  Widget otherSignInMethodRow(
    CustomTheme currentTheme,
    UserNotifier userManager,
    BuildContext context,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                userManager.signInWithGoogle(context);
              },
              icon: Image.asset("assets/google.png", width: 40, height: 40),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                currentTheme.currentColorScheme.themeType ==
                        ThemeBrightness.light
                    ? "assets/darkapple.png"
                    : "assets/apple.png",
                width: 40,
                height: 40,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                currentTheme.currentColorScheme.themeType ==
                        ThemeBrightness.light
                    ? "assets/twitter.png"
                    : "assets/darktwitter.png",
                width: 40,
                height: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget signInWithSocialMediaRow(
    LanguageLocalizationTexts localization,
    CustomTheme currentTheme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        horizontalDivideLine(),
        Text(
          localization.signInWithSocialMedia,
          style: currentTheme.textTheme.bodyMedium,
        ),
        horizontalDivideLine(),
      ],
    );
  }

  Widget horizontalDivideLine() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        color: Colors.black,
        width: double.infinity,
        height: 1,
      ),
    );
  }

  Widget rememberMeAndForgotPasswordRow(
    CustomTheme currentTheme,
    LanguageLocalizationTexts localization,
  ) {
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
            onPressed: () {},
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

  Widget signInForm(
    CustomTheme customTheme,
    BuildContext context,
    LanguageLocalizationTexts localization,
    UserNotifier userManager,
  ) => Form(
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
