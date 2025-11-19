import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/material.dart';
import '../models/ponto_coleta.dart';
import '../models/usuario.dart';
import '../models/chat_model.dart';

class ApiService {
  // ========== MATERIAIS ==========
  
  static Future<List<Material>> getMateriais({
    int pageNumber = 0,
    int pageSize = 100,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}${ApiConfig.materiais}?pageNumber=$pageNumber&pageSize=$pageSize',
        ),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => Material.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('[v0] Error fetching materiais: $e');
      return [];
    }
  }

  static Future<Material?> getMaterialById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.materiais}/$id'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        return Material.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
      return null;
    } catch (e) {
      print('[v0] Error fetching material: $e');
      return null;
    }
  }

  static Future<Material?> createMaterial(Material material) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.materiais}'),
        headers: ApiConfig.headers,
        body: json.encode(material.toJson()),
      );

      if (response.statusCode == 201) {
        return Material.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
      return null;
    } catch (e) {
      print('[v0] Error creating material: $e');
      return null;
    }
  }

  static Future<Material?> updateMaterial(int id, Material material) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.materiais}/$id'),
        headers: ApiConfig.headers,
        body: json.encode(material.toJson()),
      );

      if (response.statusCode == 200) {
        return Material.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
      return null;
    } catch (e) {
      print('[v0] Error updating material: $e');
      return null;
    }
  }

  static Future<bool> deleteMaterial(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.materiais}/$id'),
        headers: ApiConfig.headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('[v0] Error deleting material: $e');
      return false;
    }
  }

  // ========== PONTOS DE COLETA ==========

  static Future<List<PontoColeta>> getPontosColeta({
    int pageNumber = 0,
    int pageSize = 100,
    int materialId = 0,
    String term = '',
    double latitude = 0,
    double longitude = 0,
  }) async {
    try {
      var url = '${ApiConfig.baseUrl}${ApiConfig.pontosColeta}?pageNumber=$pageNumber&pageSize=$pageSize';
      
      if (materialId > 0) {
        url += '&materialId=$materialId';
      }
      if (term.isNotEmpty) {
        url += '&term=$term';
      }
      if (latitude != 0 && longitude != 0) {
        url += '&latitude=$latitude&longitude=$longitude';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => PontoColeta.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('[v0] Error fetching pontos coleta: $e');
      return [];
    }
  }

  static Future<PontoColeta?> getPontoColetaById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.pontosColeta}/$id'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        return PontoColeta.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
      return null;
    } catch (e) {
      print('[v0] Error fetching ponto coleta: $e');
      return null;
    }
  }

  static Future<PontoColeta?> createPontoColeta(PontoColeta ponto) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.pontosColeta}'),
        headers: ApiConfig.headers,
        body: json.encode(ponto.toJson()),
      );

      if (response.statusCode == 201) {
        return PontoColeta.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
      return null;
    } catch (e) {
      print('[v0] Error creating ponto coleta: $e');
      return null;
    }
  }

  static Future<PontoColeta?> updatePontoColeta(int id, PontoColeta ponto) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.pontosColeta}/$id'),
        headers: ApiConfig.headers,
        body: json.encode(ponto.toJson()),
      );

      if (response.statusCode == 200) {
        return PontoColeta.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
      return null;
    } catch (e) {
      print('[v0] Error updating ponto coleta: $e');
      return null;
    }
  }

  static Future<bool> deletePontoColeta(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.pontosColeta}/$id'),
        headers: ApiConfig.headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('[v0] Error deleting ponto coleta: $e');
      return false;
    }
  }

  // ========== USUÁRIOS ==========

  static Future<List<Usuario>> getUsuarios() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usuarios}'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => Usuario.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('[v0] Error fetching usuarios: $e');
      return [];
    }
  }

  static Future<Usuario?> getUsuarioById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usuarios}/$id'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        return Usuario.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
      return null;
    } catch (e) {
      print('[v0] Error fetching usuario: $e');
      return null;
    }
  }

  static Future<Usuario?> createUsuario(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usuarios}'),
        headers: ApiConfig.headers,
        body: json.encode(userData),
      );

      if (response.statusCode == 201) {
        return Usuario.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
      return null;
    } catch (e) {
      print('[v0] Error creating usuario: $e');
      return null;
    }
  }

  static Future<Usuario?> updateUsuario(int id, Map<String, dynamic> userData) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usuarios}/$id'),
        headers: ApiConfig.headers,
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        return Usuario.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
      return null;
    } catch (e) {
      print('[v0] Error updating usuario: $e');
      return null;
    }
  }

  static Future<bool> deleteUsuario(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usuarios}/$id'),
        headers: ApiConfig.headers,
      );

      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      print('[v0] Error deleting usuario: $e');
      return false;
    }
  }

  static Future<LoginResponse?> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usuarios}/login'),
        headers: ApiConfig.headers,
        body: json.encode({
          'email': email,
          'senha': senha,
        }),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
      return null;
    } catch (e) {
      print('[v0] Error during login: $e');
      return null;
    }
  }

  // ========== CHATS ==========

  static Future<ChatModel?> createChat(int usuarioId, int pontoColetaId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.chats}'),
        headers: ApiConfig.headers,
        body: json.encode({
          'usuarioId': usuarioId,
          'pontoColetaId': pontoColetaId,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 409) {
        return ChatModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
      return null;
    } catch (e) {
      print('[v0] Error creating chat: $e');
      return null;
    }
  }

  static Future<List<ChatModel>> getChatsByUsuario(int usuarioId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.chats}/usuario/$usuarioId'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => ChatModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('[v0] Error fetching chats: $e');
      return [];
    }
  }

  static Future<List<ChatModel>> getAllChats() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.chats}/todos'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => ChatModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('[v0] Error fetching all chats: $e');
      return [];
    }
  }

  static Future<MensagemModel?> sendMessage(
    int chatId,
    String conteudo,
    String remetente,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.chats}/$chatId/mensagens'),
        headers: ApiConfig.headers,
        body: json.encode({
          'conteudo': conteudo,
          'remetente': remetente,
        }),
      );

      if (response.statusCode == 201) {
        return MensagemModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      }
      return null;
    } catch (e) {
      print('[v0] Error sending message: $e');
      return null;
    }
  }

  static Future<List<MensagemModel>> getMessagesByChat(int chatId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.chats}/$chatId/mensagens'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => MensagemModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('[v0] Error fetching messages: $e');
      return [];
    }
  }
}
