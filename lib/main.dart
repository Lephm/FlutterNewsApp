import 'package:centranews/models/app_info.dart';
import 'package:centranews/utils/custom_navigator_settings.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppInfo.title,
      initialRoute: CustomNavigatorSettings.initialRoute,
      routes: CustomNavigatorSettings.allRoutes,
      debugShowCheckedModeBanner: false,
    );
  }
}
