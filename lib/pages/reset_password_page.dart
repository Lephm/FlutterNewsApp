import 'package:centranews/providers/localization_provider.dart';
import 'package:centranews/providers/theme_provider.dart';
import 'package:centranews/utils/full_screen_overlay_progress_bar.dart';
import 'package:centranews/utils/pop_up_message.dart';
import 'package:centranews/utils/validationhelper.dart';
import 'package:centranews/widgets/custom_form_button.dart';
import 'package:centranews/widgets/custom_safe_area.dart';
import 'package:centranews/widgets/custom_textformfield.dart';
import 'package:centranews/widgets/form_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage>
    with FullScreenOverlayProgressBar {
  final GlobalKey<FormState> _resetPasswordFormKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController resetCodeController = TextEditingController();
  bool obsecurePassword = true;
  bool obsecureConfirmedPassword = true;

  @override
  Widget build(BuildContext context) {
    var currentTheme = ref.watch(themeProvider);
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

                children: [resetPasswordIntroWidget(), resetPasswordForm()],
              ),
            ),
          ),
        ),
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,
      ),
    );
  }

  Widget resetPasswordIntroWidget() {
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
          localization.resetPassword,
          style: currentTheme.textTheme.headlineMedium,
        ),
      ],
    );
  }

  Widget resetPasswordForm() {
    var localization = ref.watch(localizationProvider);
    var currentTheme = ref.watch(themeProvider);
    return Form(
      key: _resetPasswordFormKey,
      child: Column(
        children: [
          CustomTextFormField(
            hintText: localization.enterYourResetPasswordCode,
            controller: resetCodeController,
          ),
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
            onPressed: () async {
              if (_resetPasswordFormKey.currentState!.validate()) {
                try {
                  showProgressBar(context, currentTheme);
                  await updatePassword();
                  if (mounted) {
                    showSucessfulResetPasswordMessage();
                  }
                } catch (e) {
                  if (mounted) {
                    showAlertMessage(context, e.toString(), currentTheme);
                  }
                } finally {
                  if (mounted) {
                    closeProgressBar(context);
                  }
                }
              }
            },
            content: localization.resetPassword,
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

  void showSucessfulResetPasswordMessage() {
    var currentTheme = ref.watch(themeProvider);
    var localization = ref.watch(localizationProvider);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: currentTheme.currentColorScheme.bgPrimary,

        title: BackButton(
          color: currentTheme.currentColorScheme.bgInverse,
          style: ButtonStyle(alignment: Alignment(-1.0, -1.0)),
          onPressed: () {
            Navigator.of(context).pushNamed("/");
          },
        ),
        content: Text(
          localization.resetPasswordSucessfully,
          style: currentTheme.textTheme.bodyMedium,
        ),
      ),
    );
  }

  Future<void> updatePassword() async {
    await supabase.auth.verifyOTP(
      token: resetCodeController.text,
      email: emailController.text,
      type: OtpType.recovery,
    );
    await supabase.auth.updateUser(
      UserAttributes(password: passwordController.text),
    );
  }
}
