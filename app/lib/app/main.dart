import 'dart:io';

import 'package:app/app/routes.dart';
import 'package:app/core/services/secure_storage_service.dart';
import 'package:app/modules/auth/login_screen.dart';
import 'package:app/modules/news/news_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // No desktop o sqflite usa a implementação FFI (a mesma API).
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewsHub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const _Bootstrap(),
      routes: {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.news: (_) => const NewsListScreen(),
      },
    );
  }
}

// Ao abrir o app, se já existe token guardado vai direto para a consulta.
class _Bootstrap extends StatefulWidget {
  const _Bootstrap();

  @override
  State<_Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<_Bootstrap> {
  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    String? token;
    try {
      token = await secureStorage.readToken();
    } catch (_) {
      token = null;
    }

    if (!mounted) return;
    final route = (token != null && token.isNotEmpty)
        ? AppRoutes.news
        : AppRoutes.login;
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
