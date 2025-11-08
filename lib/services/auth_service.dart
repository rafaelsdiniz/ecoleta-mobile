import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
import 'api_service.dart';

class AuthService extends ChangeNotifier {
  Usuario? _currentUser;
  bool _isLoading = false;
  String? _token;

  Usuario? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get token => _token;

  AuthService() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    final savedToken = prefs.getString('token');
    
    if (userJson != null) {
      _currentUser = Usuario.fromJson(jsonDecode(userJson));
      _token = savedToken;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String senha) async {
    _isLoading = true;
    notifyListeners();

    try {
      final loginResponse = await ApiService.login(email, senha);
      
      if (loginResponse != null) {
        _currentUser = Usuario(
          id: loginResponse.id,
          nome: loginResponse.nome,
          email: loginResponse.email,
          telefone: '', // Will be fetched from API if needed
          tipoUsuario: loginResponse.tipoUsuario,
        );
        _token = loginResponse.token;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(_currentUser!.toJson()));
        await prefs.setString('token', _token!);

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('[v0] Login error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String nome, String email, String senha, String telefone) async {
    _isLoading = true;
    notifyListeners();

    try {
      final usuario = await ApiService.createUsuario({
        'nome': nome,
        'email': email,
        'senha': senha,
        'telefone': telefone,
        'tipoUsuario': 'CLIENTE',
      });

      if (usuario != null) {
        // Auto login after registration
        return await login(email, senha);
      }
    } catch (e) {
      print('[v0] Register error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('token');
    _currentUser = null;
    _token = null;
    notifyListeners();
  }

  Future<void> updateProfile(Usuario updatedUser) async {
    if (_currentUser?.id == null) return;

    try {
      final updated = await ApiService.updateUsuario(
        _currentUser!.id!,
        updatedUser.toJson(),
      );

      if (updated != null) {
        _currentUser = updated;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(_currentUser!.toJson()));
        notifyListeners();
      }
    } catch (e) {
      print('[v0] Update profile error: $e');
    }
  }
}
