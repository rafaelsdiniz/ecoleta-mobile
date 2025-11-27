import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'admin_home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        // Se ainda está carregando, mostra splash screen
        if (authService.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF34CB79),
              ),
            ),
          );
        }

        // Se não está autenticado, vai para login
        if (!authService.isAuthenticated) {
          return const LoginScreen();
        }

        // Se é admin, vai para tela admin
        if (authService.currentUser?.isAdmin ?? false) {
          return const AdminHomeScreen();
        }

        // Se é usuário comum, vai para tela normal
        return const HomeScreen();
      },
    );
  }
}
