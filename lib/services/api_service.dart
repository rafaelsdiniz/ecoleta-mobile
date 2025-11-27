// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/material.dart';
import '../models/ponto_coleta.dart';
import '../models/usuario.dart';
import '../models/chat_model.dart';

class ApiService {
  static const String baseUrl = 'https://ecoleta-quarkus-production.up.railway.app';
  
  static Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  // ========== MATERIAIS ==========
  
  static Future<List<Material>> getMateriais({
    int pageNumber = 0,
    int pageSize = 100,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/materiais?pageNumber=$pageNumber&pageSize=$pageSize',
        ),
        headers: await _getHeaders(),
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
        Uri.parse('$baseUrl/materiais/$id'),
        headers: await _getHeaders(),
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
        Uri.parse('$baseUrl/materiais'),
        headers: await _getHeaders(),
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
        Uri.parse('$baseUrl/materiais/$id'),
        headers: await _getHeaders(),
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
        Uri.parse('$baseUrl/materiais/$id'),
        headers: await _getHeaders(),
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
      var url = '$baseUrl/pontos-coleta?pageNumber=$pageNumber&pageSize=$pageSize';
      
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
        headers: await _getHeaders(),
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
        Uri.parse('$baseUrl/pontos-coleta/$id'),
        headers: await _getHeaders(),
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
        Uri.parse('$baseUrl/pontos-coleta'),
        headers: await _getHeaders(),
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
        Uri.parse('$baseUrl/pontos-coleta/$id'),
        headers: await _getHeaders(),
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
        Uri.parse('$baseUrl/pontos-coleta/$id'),
        headers: await _getHeaders(),
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
        Uri.parse('$baseUrl/usuarios'),
        headers: await _getHeaders(),
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
        Uri.parse('$baseUrl/usuarios/$id'),
        headers: await _getHeaders(),
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
        Uri.parse('$baseUrl/usuarios'),
        headers: await _getHeaders(),
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
        Uri.parse('$baseUrl/usuarios/$id'),
        headers: await _getHeaders(),
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
        Uri.parse('$baseUrl/usuarios/$id'),
        headers: await _getHeaders(),
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
        Uri.parse('$baseUrl/usuarios/login'),
        headers: await _getHeaders(),
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
        Uri.parse('$baseUrl/chats'),
        headers: await _getHeaders(),
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
        Uri.parse('$baseUrl/chats/usuario/$usuarioId'),
        headers: await _getHeaders(),
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
        Uri.parse('$baseUrl/chats/todos'),
        headers: await _getHeaders(),
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

  static Future<List<ChatModel>> getChatsForAdmin() async {
    try {
      print('[ApiService] 🔍 Fetching admin chats...');
      
      final response = await http.get(
        Uri.parse('$baseUrl/chats/todos'),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 30));

      print('[ApiService] 📊 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        
        // DEBUG DETALHADO
        print('[ApiService] 🔎 ANALYZING API RESPONSE STRUCTURE:');
        if (data.isNotEmpty) {
          final firstChat = data.first;
          print('[ApiService] 📋 FIRST CHAT KEYS: ${firstChat.keys}');
          print('[ApiService] 📋 FIRST CHAT FULL DATA: $firstChat');
          
          // Verifique a estrutura do usuário
          if (firstChat['usuario'] != null) {
            print('[ApiService] 👤 USER OBJECT: ${firstChat['usuario']}');
            print('[ApiService] 👤 USER KEYS: ${firstChat['usuario'].keys}');
          } else {
            print('[ApiService] 👤 USER OBJECT: NULL - checking for direct fields');
            print('[ApiService] 👤 usuarioNome: ${firstChat['usuarioNome']}');
            print('[ApiService] 👤 usuarioEmail: ${firstChat['usuarioEmail']}');
          }
          
          // Verifique a estrutura do ponto de coleta
          if (firstChat['pontoColeta'] != null) {
            print('[ApiService] 🏪 PONTO COLETA OBJECT: ${firstChat['pontoColeta']}');
            print('[ApiService] 🏪 PONTO COLETA KEYS: ${firstChat['pontoColeta'].keys}');
          } else {
            print('[ApiService] 🏪 PONTO COLETA OBJECT: NULL - checking for direct fields');
            print('[ApiService] 🏪 pontoColetaNome: ${firstChat['pontoColetaNome']}');
          }
        } else {
          print('[ApiService] 📭 API returned empty chats list');
        }
        
        final chats = data.map((json) => ChatModel.fromJson(json)).toList();
        print('[ApiService] ✅ Total chats parsed: ${chats.length}');
        return chats;
        
      } else {
        print('[ApiService] ❌ Failed to load chats. Status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('[ApiService] 💥 Error getting admin chats: $e');
      return [];
    }
  }

  // ========== MENSAGENS ==========

  static Future<List<MessageModel>> getMessagesByChat(int chatId) async {
    try {
      print('[ApiService] Fetching messages for chat: $chatId');
      
      final response = await http.get(
        Uri.parse('$baseUrl/chats/$chatId/mensagens'),
        headers: await _getHeaders(),
      );

      print('[ApiService] Response status: ${response.statusCode}');
      print('[ApiService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        
        print('[ApiService] Raw messages data: $data');
        
        final messages = data.map((json) {
          try {
            return MessageModel.fromJson(json);
          } catch (e) {
            print('[ApiService] Error parsing message: $e');
            print('[ApiService] Problematic JSON: $json');
            rethrow;
          }
        }).toList();
        
        // DEBUG: Log das mensagens processadas
        for (var i = 0; i < messages.length; i++) {
          final msg = messages[i];
          print('[ApiService] Message $i - Conteudo: "${msg.conteudo}" | Remetente: ${msg.remetente} | Tipo: ${msg.remetente.runtimeType}');
        }
        
        return messages;
      } else {
        print('[ApiService] Failed to load messages. Status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('[ApiService] Error fetching messages: $e');
      return [];
    }
  }

  static Future<MessageModel?> sendMessage(
    int chatId,
    String conteudo,
    String remetente,
  ) async {
    try {
      print('[ApiService] Sending message to chat $chatId: "$conteudo" as $remetente');
      
      final response = await http.post(
        Uri.parse('$baseUrl/chats/$chatId/mensagens'),
        headers: await _getHeaders(),
        body: json.encode({
          'conteudo': conteudo,
          'remetente': remetente,
        }),
      );

      print('[ApiService] Send message status: ${response.statusCode}');
      print('[ApiService] Send message response: ${response.body}');

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return MessageModel.fromJson(jsonResponse);
      } else {
        print('[ApiService] Send message failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('[ApiService] Error sending message: $e');
      return null;
    }
  }
}