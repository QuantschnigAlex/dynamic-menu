import 'package:dynamic_menu/features/qr_scanner/qr_scanner.dart';
import 'package:dynamic_menu/features/login/login_screen.dart';
import 'package:dynamic_menu/features/login/splash_screen.dart';
import 'package:dynamic_menu/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  const anonKey = String.fromEnvironment("ANONKEY");
  const apiURL = String.fromEnvironment("APIURL");

  await Supabase.initialize(
    url: apiURL,
    anonKey: anonKey,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final supabase = Supabase.instance.client;

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) {
        return const SplashPage();
      },
      routes: [
        GoRoute(
          path: "qr",
          builder: (context, state) {
            return const QRScreen();
          },
        ),
        GoRoute(
          path: "login",
          builder: (context, state) {
            return const LoginScreen();
          },
        ),
      ],
    )
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: myTheme,
      routerConfig: _router,
    );
  }
}
