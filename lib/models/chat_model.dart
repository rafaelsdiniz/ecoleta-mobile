// models/chat_model.dart
import 'enums.dart';

class MessageModel {
  final int? id;
  final String conteudo;
  final Remetente remetente;
  final DateTime dataEnvio;
  final int chatId;

  MessageModel({
    this.id,
    required this.conteudo,
    required this.remetente,
    required this.dataEnvio,
    required this.chatId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    try {
      return MessageModel(
        id: _parseInt(json['id']),
        conteudo: _parseString(json['conteudo']) ?? '',
        remetente: _parseRemetente(json['remetente']),
        dataEnvio: _parseDateTime(json['dataEnvio']),
        chatId: _parseInt(json['chatId']) ?? 0,
      );
    } catch (e) {
      print('[MessageModel] Error parsing JSON: $e');
      print('[MessageModel] JSON data: $json');
      // Return default message to avoid breaking the app
      return MessageModel(
        conteudo: 'Mensagem não carregada',
        remetente: Remetente.USUARIO,
        dataEnvio: DateTime.now(),
        chatId: 0,
      );
    }
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  static Remetente _parseRemetente(dynamic value) {
    if (value is String) {
      switch (value) {
        case 'USUARIO': return Remetente.USUARIO;
        case 'PONTO_COLETA': return Remetente.PONTO_COLETA;
        case 'ADM': return Remetente.ADM;
        default: return Remetente.USUARIO;
      }
    }
    return Remetente.USUARIO;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conteudo': conteudo,
      'remetente': remetente.name,
      'dataEnvio': dataEnvio.toIso8601String(),
      'chatId': chatId,
    };
  }

  @override
  String toString() {
    return 'MessageModel(id: $id, conteudo: $conteudo, remetente: $remetente, dataEnvio: $dataEnvio, chatId: $chatId)';
  }
}

class ChatModel {
  final int id;
  final int usuarioId;
  final String usuarioNome;
  final String? usuarioEmail;
  final int pontoColetaId;
  final String pontoColetaNome;
  final DateTime dataCriacao;
  final MessageModel? ultimaMensagem;

  ChatModel({
    required this.id,
    required this.usuarioId,
    required this.usuarioNome,
    this.usuarioEmail,
    required this.pontoColetaId,
    required this.pontoColetaNome,
    required this.dataCriacao,
    this.ultimaMensagem,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    try {
      print('[ChatModel] 🧩 Parsing JSON: $json');
      
      // Tente diferentes estruturas possíveis da API
      String? usuarioNome;
      String? usuarioEmail;
      String? pontoColetaNome;
      
      // ESTRUTURA 1: Campos diretos (usuarioNome, pontoColetaNome)
      if (json['usuarioNome'] != null) {
        usuarioNome = _parseString(json['usuarioNome']);
        print('[ChatModel] ✅ Found usuarioNome directly: $usuarioNome');
      }
      
      if (json['pontoColetaNome'] != null) {
        pontoColetaNome = _parseString(json['pontoColetaNome']);
        print('[ChatModel] ✅ Found pontoColetaNome directly: $pontoColetaNome');
      }
      
      // ESTRUTURA 2: Objetos aninhados (usuario { nome }, pontoColeta { nome })
      if (usuarioNome == null && json['usuario'] != null) {
        final usuario = json['usuario'];
        usuarioNome = _parseString(usuario['nome']) ?? 
                     _parseString(usuario['usuarioNome']) ?? 
                     _parseString(usuario['name']);
        usuarioEmail = _parseString(usuario['email']);
        print('[ChatModel] ✅ Found usuario object - nome: $usuarioNome, email: $usuarioEmail');
      }
      
      if (pontoColetaNome == null && json['pontoColeta'] != null) {
        final ponto = json['pontoColeta'];
        pontoColetaNome = _parseString(ponto['nome']) ?? 
                         _parseString(ponto['pontoColetaNome']) ?? 
                         _parseString(ponto['name']);
        print('[ChatModel] ✅ Found pontoColeta object - nome: $pontoColetaNome');
      }
      
      // ESTRUTURA 3: Nomes alternativos
      if (usuarioNome == null) {
        usuarioNome = _parseString(json['nomeUsuario']) ?? 
                     _parseString(json['userName']) ?? 
                     _parseString(json['userNome']);
      }
      
      if (pontoColetaNome == null) {
        pontoColetaNome = _parseString(json['nomePontoColeta']) ?? 
                         _parseString(json['collectionPointName']) ?? 
                         _parseString(json['pontoNome']);
      }
      
      // Valores padrão como último recurso
      usuarioNome = usuarioNome ?? 'Usuário';
      pontoColetaNome = pontoColetaNome ?? 'Ponto de Coleta';
      
      final chat = ChatModel(
        id: _parseInt(json['id']) ?? 0,
        usuarioId: _parseInt(json['usuarioId']) ?? _parseInt(json['usuario']?['id']) ?? 0,
        usuarioNome: usuarioNome,
        usuarioEmail: usuarioEmail ?? _parseString(json['usuarioEmail']),
        pontoColetaId: _parseInt(json['pontoColetaId']) ?? _parseInt(json['pontoColeta']?['id']) ?? 0,
        pontoColetaNome: pontoColetaNome,
        dataCriacao: _parseDateTime(json['dataCriacao'] ?? json['createdAt']),
        ultimaMensagem: json['ultimaMensagem'] != null 
            ? MessageModel.fromJson(Map<String, dynamic>.from(json['ultimaMensagem']))
            : null,
      );
      
      print('[ChatModel] 🎉 Chat parsed successfully: ${chat.usuarioNome} - ${chat.pontoColetaNome}');
      return chat;
      
    } catch (e) {
      print('[ChatModel] 💥 Error parsing chat: $e');
      print('[ChatModel] 💥 Problematic JSON: $json');
      
      // Chat padrão em caso de erro
      return ChatModel(
        id: _parseInt(json['id']) ?? 0,
        usuarioId: 0,
        usuarioNome: 'Usuário',
        pontoColetaId: 0,
        pontoColetaNome: 'Ponto de Coleta',
        dataCriacao: DateTime.now(),
      );
    }
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.isEmpty ? null : value;
    return value.toString();
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'usuarioNome': usuarioNome,
      'usuarioEmail': usuarioEmail,
      'pontoColetaId': pontoColetaId,
      'pontoColetaNome': pontoColetaNome,
      'dataCriacao': dataCriacao.toIso8601String(),
      'ultimaMensagem': ultimaMensagem?.toJson(),
    };
  }

  @override
  String toString() {
    return 'ChatModel(id: $id, usuarioNome: $usuarioNome, pontoColetaNome: $pontoColetaNome)';
  }
}