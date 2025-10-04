import 'package:centranews/models/app_info.dart';
import 'package:centranews/utils/custom_navigator_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://abugihnaowqdwntoervn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFidWdpaG5hb3dxZHdudG9lcnZuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk1MjE5MzcsImV4cCI6MjA3NTA5NzkzN30.SkLffRRkYKoP8V_syZk2WM6MBUUggwVQERY64sqk25s',
  );
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
