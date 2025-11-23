import 'package:centranews/models/app_info.dart';
import 'package:centranews/utils/custom_navigator_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:localstorage/localstorage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await MobileAds.instance.initialize();
  }
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.black),
  );
  await dotenv.load(fileName: ".env");
  await initLocalStorage();
  String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? "";
  String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? "";
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(hoverColor: Colors.transparent),
      title: AppInfo.title,
      initialRoute: CustomNavigatorSettings.initialRoute,
      routes: CustomNavigatorSettings.allRoutes,
      debugShowCheckedModeBanner: false,
      navigatorKey: CustomNavigatorSettings.navigatorKey,
      onGenerateRoute: CustomNavigatorSettings.onGenerateRoute,
    );
  }
}
