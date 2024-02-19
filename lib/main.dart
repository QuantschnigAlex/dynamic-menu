import 'package:dynamic_menu/features/login/login_screen.dart';
import 'package:dynamic_menu/features/login/splash_screen.dart';
import 'package:dynamic_menu/theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  const anonKey = String.fromEnvironment("ANONKEY");
  const apiURL = String.fromEnvironment("APIURL");

  await Supabase.initialize(
    url: apiURL,
    anonKey: anonKey,
  );

  runApp(
    const MyApp(),
  );
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: myTheme,
      // home: const LoginScreen(),
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashPage(),
        "/login": (context) => const LoginScreen(),
      },
    );
  }
}
