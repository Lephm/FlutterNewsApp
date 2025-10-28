import 'package:centranews/providers/local_user_provider.dart';
import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/validationhelper.dart';
import 'package:centranews/widgets/custom_form_button.dart';
import 'package:centranews/widgets/custom_safe_area.dart';
import 'package:centranews/widgets/custom_textformfield.dart';
import 'package:centranews/widgets/form_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool obsecurePassword = true;
  bool obsecureConfirmedPassword = true;

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return CustomSafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: FormAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
            child: SizedBox(
              width: double.infinity,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  signUpIntroWidget(),
                  signUnForm(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/sign_in");
                      },
                      child: Text(
                        localization.alreadyHaveAnAccountSignInHere,
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

  Widget signUpIntroWidget() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    return Column(
      children: [
        SizedBox(height: 80),
        Image(image: AssetImage("assets/app_icon.png"), height: 150),
        SizedBox(height: 10),
        Text(
          localization.welcome,
          style: currentTheme.textTheme.headlineMedium,
        ),
        Text(
          localization.signUp,
          style: currentTheme.textTheme.bodyLightMedium,
        ),
      ],
    );
  }

  Widget signUnForm() {
    var localization = ref.watch(localizationProvider);
    var userManager = ref.watch(userProvider.notifier);
    return Form(
      key: _signUpFormKey,
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
            obscureText: obsecurePassword,
            suffixIcon: displayPasswordVisibilityIcon(),
          ),
          CustomTextFormField(
            hintText: localization.confirmPassword,
            controller: confirmPasswordController,
            validatorFunc: (value) {
              return isTheSamePassword(
                passwordController.text,
                confirmPasswordController.text,
                localization,
              );
            },
            obscureText: obsecureConfirmedPassword,
            suffixIcon: displayConfirmPasswordVisibilityIcon(),
          ),
          CustomFormButton(
            onPressed: () {
              if (_signUpFormKey.currentState!.validate()) {
                userManager.createAccountWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text,
                  context: context,
                );
              }
            },
            content: localization.signUp,
          ),
        ],
      ),
    );
  }

  IconButton displayPasswordVisibilityIcon() {
    return IconButton(
      onPressed: () {
        switchobsecurePassword();
      },
      icon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        child: Icon(obsecurePassword ? Icons.visibility : Icons.visibility_off),
      ),
    );
  }

  IconButton displayConfirmPasswordVisibilityIcon() {
    return IconButton(
      onPressed: () {
        switchobsecureConfirmedPassword();
      },
      icon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        child: Icon(
          obsecureConfirmedPassword ? Icons.visibility : Icons.visibility_off,
        ),
      ),
    );
  }

  void switchobsecurePassword() {
    setState(() {
      obsecurePassword = !obsecurePassword;
    });
  }

  void switchobsecureConfirmedPassword() {
    setState(() {
      obsecureConfirmedPassword = !obsecureConfirmedPassword;
    });
  }
}
