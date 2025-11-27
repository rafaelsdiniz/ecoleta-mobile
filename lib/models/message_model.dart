// models/message_model.dart
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