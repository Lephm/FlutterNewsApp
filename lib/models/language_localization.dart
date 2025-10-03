class LanguageLocalizationTexts {
  const LanguageLocalizationTexts({
    required this.signIn,
    required this.signOut,
    required this.enterYourEmail,
    required this.enterYourPassword,
    required this.rememberMe,
    required this.forgotPassword,
    required this.welcome,
    required this.signInWithSocialMedia,
    required this.signInToYourAccount,
  });
  final String signIn;
  final String signOut;
  final String enterYourEmail;
  final String enterYourPassword;
  final String rememberMe;
  final String forgotPassword;
  final String welcome;
  final String signInWithSocialMedia;
  final String signInToYourAccount;
}

var engLocalization = LanguageLocalizationTexts(
  signIn: "Sign In",
  signOut: "Sign Out",
  enterYourEmail: "Enter your email",
  enterYourPassword: "Enter Your Password",
  rememberMe: "Remember me",
  forgotPassword: "Forgot Password",
  welcome: "Welcome",
  signInWithSocialMedia: "Sign in with Social media",
  signInToYourAccount: "Sign in to your account ",
);
