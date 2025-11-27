import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'screens/welcome_screen.dart';
import 'screens/auth_wrapper.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';

void main() {
  // Aplica otimização de conexões HTTP no app inteiro
  HttpOverrides.global = MyHttpOverrides();
  
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      // evita que o flutter fique travado tentando conectar
      ..connectionTimeout = const Duration(seconds: 5)
      // mantém conexões abertas e reaproveita (muito mais rápido)
      ..idleTimeout = const Duration(seconds: 15);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'Ecoleta Mobile',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF34CB79)),
          useMaterial3: true,
        ),
        home: const WelcomeScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/guest': (context) => const HomeScreen(isGuest: true),
          '/auth': (context) => const AuthWrapper(),
        },
      ),
    );
  }
}
