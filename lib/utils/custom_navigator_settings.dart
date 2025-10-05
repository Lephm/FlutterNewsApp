import 'package:centranews/pages/home_page.dart';
import 'package:centranews/pages/sign_in.dart';
import 'package:centranews/pages/sign_up.dart';
import 'package:flutter/material.dart';

abstract class CustomNavigatorSettings {
  static final Map<String, Widget Function(BuildContext context)> allRoutes = {
    //TODO: change the home route to home
    "/": (context) => HomePage(),
    "/home": (context) => HomePage(),
    "/sign_in": (context) => SignIn(),
    "/sign_up": (context) => SignUp(),
  };

  static String initialRoute = '/';

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
