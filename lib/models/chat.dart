// models/chat_model.dart
import 'message_model.dart'; // Import do modelo separado

class ChatModel {
  final int id;
  final int usuarioId;
  final String usuarioNome;
  final String? usuarioEmail;
  final int pontoColetaId;
  final String pontoColetaNome;
  final DateTime dataCriacao;
  final MessageModel? ultimaMensagem; // Use MensagemModel do arquivo separado

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
    return ChatModel(
      id: json['id'] as int,
      usuarioId: json['usuarioId'] as int,
      usuarioNome: json['usuarioNome'] as String,
      usuarioEmail: json['usuarioEmail'] as String?,
      pontoColetaId: json['pontoColetaId'] as int,
      pontoColetaNome: json['pontoColetaNome'] as String,
      dataCriacao: DateTime.parse(json['dataCriacao'] as String),
      ultimaMensagem: json['ultimaMensagem'] != null 
          ? MessageModel.fromJson(json['ultimaMensagem'] as Map<String, dynamic>)
          : null,
    );
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
}