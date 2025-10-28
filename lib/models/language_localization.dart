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
    required this.youDoNotHaveAnyBookmark,
    required this.politics,
    required this.asia,
    required this.europe,
    required this.america,
    required this.economics,
    required this.finance,
    required this.stocks,
    required this.crypto,
    required this.worldNews,
    required this.lawAndJustice,
    required this.science,
    required this.technology,
    required this.health,
    required this.business,
    required this.cultureAndArts,
    required this.sports,
    required this.environment,
    required this.media,
    required this.search,
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
  final String youDoNotHaveAnyBookmark;
  final String search;

  //Categories label
  final String politics;
  final String asia;
  final String europe;
  final String america;
  final String economics;
  final String finance;
  final String stocks;
  final String crypto;
  final String worldNews;
  final String lawAndJustice;
  final String science;
  final String technology;
  final String health;
  final String business;
  final String cultureAndArts;
  final String sports;
  final String environment;
  final String media;

  //TODO implement this map
  Map<String, String> _englishLabelTextsToLocalTextsMap() {
    return {
      "Politics": politics,
      "Asia": asia,
      "Europe": europe,
      "America": america,
      "Economics": finance,
      "Finance": finance,
      "Stocks": stocks,
      "Crypto": crypto,
      "World News": worldNews,
      "Laws And Justice": lawAndJustice,
      "Science": science,
      "Technology": technology,
      "Health": health,
      "Business": business,
      "Culture And Arts": cultureAndArts,
      "Sports": sports,
      "Environment": environment,
      "Media": media,
    };
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
  youDoNotHaveAnyBookmark: "You do not have any bookmark",
  search: "Search",
  politics: "Politics",
  asia: "Asia",
  europe: "Europe",
  america: "America",
  economics: "Economics",
  finance: "Finance",
  stocks: "Stocks",
  crypto: "Crypto",
  worldNews: "World News",
  lawAndJustice: "Law And Justice",
  science: "Science",
  technology: "Technology",
  health: "Health",
  business: "Business",
  cultureAndArts: "Culture And Arts",
  sports: "Sports",
  environment: "Environment",
  media: "Media",
);

var vietLocalization = const LanguageLocalizationTexts(
  signIn: "Đăng nhập",
  signOut: "Đăng xuất",
  signUp: "Đăng ký",
  enterYourEmail: "Email",
  enterYourPassword: "Mật khẩu",
  rememberMe: "Ghi nhớ đăng nhập",
  forgotPassword: "Quên mật khẩu",
  welcome: "Chào mừng",
  signInWithSocialMedia: "Đăng nhập bằng tài khoản mạng xã hội",
  signInToYourAccount: "Đăng nhập",
  dontHaveAnAccountSignUpHere: "Chưa có tài khoản? Đăng ký tại đây",
  alreadyHaveAnAccountSignInHere: "Đã có tài khoản? Đăng nhập tại đây",
  confirmPassword: "Xác nhận mật khẩu",
  pleaseEnterAnEmail: "Vui lòng nhập email",
  pleaseEnterAValidEmail: "Vui lòng nhập email hợp lệ",
  pleaseEnterAPassword: "Vui lòng nhập mật khẩu",
  passwordMustBeLonger: "Mật khẩu quá ngắn",
  pleaseConfirmYourPassword: "Vui lòng xác nhận mật khẩu",
  passwordsDoNotMatch: "Mật khẩu không khớp",
  signInSucessFullyMessage: "Đăng nhập thành công",
  youreNotLoggedIn: "Bạn chưa đăng nhập",
  news: "Tin tức",
  discovery: "Khám phá",
  bookmarks: "Lưu bài",
  youHaveSucessfullySignedOut: "Đăng xuất thành công",
  settings: "Cài đặt",
  readMore: "Xem thêm",
  sources: "Nguồn",
  copiedSucessfully: "Đã sao chép liên kết",
  lowTrust: "Độ tin cậy thấp",
  mediumTrust: "Độ tin cậy trung bình",
  highTrust: "Độ tin cậy cao",
  cantFindRelevantArticles: "Không tìm thấy bài viết phù hợp",
  errorLoadingArticles: "Có lỗi khi tải bài viết",
  youMustSignInPrompt: "Bạn cần phải đăng nhập để sử dụng tính năng này",
  youDoNotHaveAnyBookmark: "Chưa có bài nào được lưu",
  politics: "Chính trị",
  asia: "Châu Á",
  europe: "Châu Âu",
  america: "Châu Mỹ",
  economics: "Kinh tế",
  finance: "Tài chính",
  stocks: "Cổ phiếu",
  crypto: "Tiền số",
  worldNews: "Tin tức thế giới",
  lawAndJustice: "Pháp luật",
  science: "Khoa học",
  technology: "Công nghệ",
  health: "Sức khỏe",
  business: "Kinh doanh",
  cultureAndArts: "Văn hóa & Nghệ thuật",
  sports: "Thể thao",
  environment: "Môi trường",
  media: "Truyền thông",
  search: "Tìm Kiếm",
);
