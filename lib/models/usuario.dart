import '../config/api_config.dart';
import 'enums.dart';

class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String telefone;
  final TipoUsuario tipoUsuario;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    this.tipoUsuario = TipoUsuario.CLIENTE,
  });

  bool get isAdmin => tipoUsuario == TipoUsuario.ADMIN;

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'] ?? '',
      tipoUsuario: json['tipoUsuario'] != null
          ? TipoUsuario.values.firstWhere(
              (e) => e.name == json['tipoUsuario'],
              orElse: () => TipoUsuario.CLIENTE,
            )
          : TipoUsuario.CLIENTE,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'tipoUsuario': tipoUsuario.name,
    };
  }

  Map<String, dynamic> toJsonWithPassword(String senha) {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
      'telefone': telefone,
      'tipoUsuario': tipoUsuario.name,
    };
  }
}

class LoginResponse {
  final int id;
  final String nome;
  final String email;
  final TipoUsuario tipoUsuario;
  final String token;

  LoginResponse({
    required this.id,
    required this.nome,
    required this.email,
    required this.tipoUsuario,
    required this.token,
  });

  bool get isAdmin => tipoUsuario == TipoUsuario.ADMIN;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      tipoUsuario: json['tipoUsuario'] != null
          ? TipoUsuario.values.firstWhere(
              (e) => e.name == json['tipoUsuario'],
              orElse: () => TipoUsuario.CLIENTE,
            )
          : TipoUsuario.CLIENTE,
      token: json['token'] ?? '',
    );
  }
}
