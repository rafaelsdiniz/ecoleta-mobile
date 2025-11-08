import 'enums.dart';

class ChatModel {
  final int? id;
  final int usuarioId;
  final String usuarioNome;
  final int pontoColetaId;
  final String pontoColetaNome;
  final DateTime dataCriacao;
  final List<MensagemModel> mensagens;

  ChatModel({
    this.id,
    required this.usuarioId,
    required this.usuarioNome,
    required this.pontoColetaId,
    required this.pontoColetaNome,
    DateTime? dataCriacao,
    this.mensagens = const [],
  }) : dataCriacao = dataCriacao ?? DateTime.now();

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      usuarioId: json['usuarioId'] ?? json['usuario']?['id'],
      usuarioNome: json['usuarioNome'] ?? json['usuario']?['nome'] ?? '',
      pontoColetaId: json['pontoColetaId'] ?? json['pontoColeta']?['id'],
      pontoColetaNome: json['pontoColetaNome'] ?? json['pontoColeta']?['nome'] ?? '',
      dataCriacao: json['dataCriacao'] != null
          ? DateTime.parse(json['dataCriacao'])
          : DateTime.now(),
      mensagens: json['mensagens'] != null
          ? (json['mensagens'] as List)
              .map((m) => MensagemModel.fromJson(m))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuarioId': usuarioId,
      'pontoColetaId': pontoColetaId,
    };
  }
}

class MensagemModel {
  final int? id;
  final String conteudo;
  final Remetente remetente;
  final DateTime dataEnvio;

  MensagemModel({
    this.id,
    required this.conteudo,
    required this.remetente,
    DateTime? dataEnvio,
  }) : dataEnvio = dataEnvio ?? DateTime.now();

  bool get isUsuario => remetente == Remetente.USUARIO;
  bool get isPontoColeta => remetente == Remetente.PONTO_COLETA;

  factory MensagemModel.fromJson(Map<String, dynamic> json) {
    return MensagemModel(
      id: json['id'],
      conteudo: json['conteudo'] ?? '',
      remetente: json['remetente'] != null
          ? Remetente.values.firstWhere(
              (e) => e.name == json['remetente'],
              orElse: () => Remetente.USUARIO,
            )
          : Remetente.USUARIO,
      dataEnvio: json['dataEnvio'] != null
          ? DateTime.parse(json['dataEnvio'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conteudo': conteudo,
      'remetente': remetente.name,
    };
  }
}
