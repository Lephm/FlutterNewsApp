//TODO: fully implement language localization with categories language map
class LanguageLocalizationTexts {
  const LanguageLocalizationTexts({
    required this.signIn,
    required this.signOut,
    required this.signUp,
    required this.enterYourEmail,
    required this.enterYourPassword,
    required this.rememberMe,
    required this.forgotPassword,
    required this.welcome,
    required this.signInWithSocialMedia,
    required this.signInToYourAccount,
    required this.dontHaveAnAccountSignUpHere,
    required this.alreadyHaveAnAccountSignInHere,
    required this.confirmPassword,
    required this.pleaseEnterAnEmail,
    required this.pleaseEnterAPassword,
    required this.passwordMustBeLonger,
    required this.pleaseEnterAValidEmail,
    required this.pleaseConfirmYourPassword,
    required this.passwordsDoNotMatch,
    required this.signInSucessFullyMessage,
    required this.youreNotLoggedIn,
    required this.news,
    required this.discovery,
    required this.bookmarks,
    required this.youHaveSucessfullySignedOut,
    required this.settings,
    required this.readMore,
    required this.sources,
    required this.copiedSucessfully,
    required this.lowTrust,
    required this.mediumTrust,
    required this.highTrust,
    required this.cantFindRelevantArticles,
    required this.errorLoadingArticles,
    required this.youMustSignInPrompt,
  });

  final String signIn;
  final String signUp;
  final String signOut;
  final String enterYourEmail;
  final String enterYourPassword;
  final String rememberMe;
  final String forgotPassword;
  final String welcome;
  final String signInWithSocialMedia;
  final String signInToYourAccount;
  final String dontHaveAnAccountSignUpHere;
  final String alreadyHaveAnAccountSignInHere;
  final String confirmPassword;
  final String pleaseEnterAnEmail;
  final String pleaseEnterAPassword;
  final String passwordMustBeLonger;
  final String pleaseEnterAValidEmail;
  final String pleaseConfirmYourPassword;
  final String passwordsDoNotMatch;
  final String signInSucessFullyMessage;
  final String youreNotLoggedIn;
  final String news;
  final String discovery;
  final String bookmarks;
  final String youHaveSucessfullySignedOut;
  final String settings;
  final String readMore;
  final String sources;
  final String copiedSucessfully;
  final String lowTrust;
  final String mediumTrust;
  final String highTrust;
  final String cantFindRelevantArticles;
  final String errorLoadingArticles;
  final String youMustSignInPrompt;

  //TODO implement this map
  Map<String, String> _englishLabelTextsToLocalTextsMap() {
    return {"Finance": "Kinh tế"};
  }

  String getLocalLanguageLabelText(String engLabel) {
    return _englishLabelTextsToLocalTextsMap()[engLabel] ?? engLabel;
  }
}

var engLocalization = const LanguageLocalizationTexts(
  signIn: "Sign In",
  signOut: "Sign Out",
  signUp: "Sign Up",
  enterYourEmail: "Enter your email",
  enterYourPassword: "Enter Your Password",
  rememberMe: "Remember me",
  forgotPassword: "Forgot Password",
  welcome: "Welcome",
  signInWithSocialMedia: "Sign in with Social media",
  signInToYourAccount: "Sign in to your account ",
  dontHaveAnAccountSignUpHere: "Don't have an account, Sign up here",
  alreadyHaveAnAccountSignInHere: "Already have an account Sign in here",
  confirmPassword: "Confirm Password",
  pleaseEnterAnEmail: "Please Enter An Email",
  pleaseEnterAValidEmail: "Please enter a valid email",
  pleaseEnterAPassword: "Please Enter A Password",
  passwordMustBeLonger: "Password must be longer",
  pleaseConfirmYourPassword: "Please confirm your password",
  passwordsDoNotMatch: "Passwords do not match",
  signInSucessFullyMessage: "You Have Sign In Sucessfully",
  youreNotLoggedIn: "You're not logged in",
  news: "News",
  discovery: "Discovery",
  bookmarks: "Bookmarks",
  youHaveSucessfullySignedOut: "You have sucessfully signed out",
  settings: "Settings",
  readMore: "Read more",
  sources: "Sources",
  copiedSucessfully: "Copied Link Sucessfully",
  lowTrust: "Low Trust",
  mediumTrust: "Medium Trust",
  highTrust: "High Trust",
  cantFindRelevantArticles: "Can't Find Relevant Articles",
  errorLoadingArticles: "There was an error loading articles",
  youMustSignInPrompt: "You must sign in to use this feature",
);
