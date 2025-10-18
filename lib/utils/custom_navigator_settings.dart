import 'package:centranews/pages/full_article_page.dart';
import 'package:centranews/pages/home_page.dart';
import 'package:centranews/pages/sign_in.dart';
import 'package:centranews/pages/sign_up.dart';
import 'package:flutter/material.dart';

abstract class CustomNavigatorSettings {
  static final Map<String, Widget Function(BuildContext context)> allRoutes = {
    "/": (context) => HomePage(),
    "/sign_in": (context) => SignIn(),
    "/sign_up": (context) => SignUp(),
  };

  static String initialRoute = '/';

  //TODO add domain name
  static const String domainName = "";

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name!.contains("full_article")) {
      final uri = Uri.parse(settings.name!);
      final String formatedUri = uri.toString();
      final arg = formatedUri.split("/").last;
      return MaterialPageRoute(builder: (context) => FullArticlePage(arg: arg));
    }
    return MaterialPageRoute(builder: (context) => HomePage());
  }

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
