import 'package:app/app/routes.dart';
import 'package:app/modules/auth/login_screen.dart';
import 'package:app/modules/settings/settings_screen.dart';
import 'package:app/modules/shell/main_scaffold.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyNews',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // The app opens straight into the shell — there is no login gate.
      // The login screen exists only as the target of the Drawer's "Logout"
      // (pushReplacement), which is a required navigation case (req #2).
      initialRoute: AppRoutes.main,
      // Centralized named routes for the ROOT navigator (requirement #1).
      routes: {
        AppRoutes.main: (_) => const MainScaffold(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.settings: (_) => const SettingsScreen(),
      },
    );
  }
}
