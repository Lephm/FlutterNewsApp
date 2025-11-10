import 'package:centranews/pages/full_article_page.dart';
import 'package:centranews/pages/home_page.dart';
import 'package:centranews/pages/reset_password_page.dart';
import 'package:centranews/pages/reset_password_prompt_page.dart';
import 'package:centranews/pages/searched_articles_page.dart';
import 'package:centranews/pages/sign_in.dart';
import 'package:centranews/pages/sign_up.dart';
import 'package:flutter/material.dart';

abstract class CustomNavigatorSettings {
  static final Map<String, Widget Function(BuildContext context)> allRoutes = {
    "/": (context) => PopScope(canPop: false, child: HomePage()),
    "/sign_in": (context) => PopScope(canPop: false, child: SignIn()),
    "/sign_up": (context) => PopScope(canPop: false, child: SignUp()),
    "/search_articles": (context) =>
        PopScope(canPop: false, child: SearchedArticlesPage()),
    "/reset_password_prompt": (context) =>
        PopScope(canPop: false, child: ResetPasswordPromptPage()),
    "/reset_password": (context) =>
        PopScope(canPop: false, child: ResetPasswordPage()),
  };

  static String initialRoute = '/';

  //TODO add domain name
  static const String domainName = "";

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name!.contains("full_article")) {
      final uri = Uri.parse(settings.name!);
      final String formatedUri = uri.toString();
      final arg = formatedUri.split("/").last;
      return MaterialPageRoute(
        builder: (context) =>
            PopScope(canPop: false, child: FullArticlePage(arg: arg)),
      );
    }
    return MaterialPageRoute(
      builder: (context) => PopScope(canPop: false, child: HomePage()),
    );
  }

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
