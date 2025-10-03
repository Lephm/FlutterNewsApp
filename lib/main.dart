import 'package:centranews/models/app_info.dart';
import 'package:centranews/utils/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppInfo.title,
      initialRoute: customNavigator.initialRoute,
      routes: customNavigator.allRoutes,
    );
  }
}
