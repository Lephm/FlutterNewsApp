import 'package:centranews/models/custom_theme.dart';
import 'package:centranews/models/language_localization.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/validationhelper.dart';
import 'package:centranews/widgets/custom_checkbox.dart';
import 'package:centranews/widgets/custom_form_button.dart';
import 'package:centranews/widgets/custom_textformfield.dart';
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
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

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
            signInForm(currentTheme, context, localization),
            rememberMeAndForgotPasswordRow(currentTheme, localization),
          ],
        ),
      ),
      backgroundColor: currentTheme.currentColorScheme.bgPrimary,
    );
  }

  Padding rememberMeAndForgotPasswordRow(
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
  ) => Form(
    key: _signInFormKey,
    child: Column(
      children: [
        CustomTextFormField(
          hintText: localization.enterYourEmail,
          controller: emailController,
          validatorFunc: isEmailValid,
        ),
        CustomTextFormField(
          hintText: localization.enterYourPassword,
          controller: passwordController,
          validatorFunc: isPasswordValid,
          obscureText: obsecureText,
          suffixIcon: displayPasswordVisibilityIcon(),
        ),
        CustomFormButton(
          onPressed: () {
            if (_signInFormKey.currentState!.validate()) {}
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
