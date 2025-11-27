import '../config/api_config.dart';
import 'material.dart';
import 'telefone.dart';
import 'dia_funcionamento.dart';

class PontoColeta {
  final int? id;
  final String nome;
  final String? descricao;
  final String? email;
  final String? telefone;
  final String endereco;
  final double latitude;
  final double longitude;
  final String? imagemBase64;
  final String? nomeImagem;
  final List<Material> materiais;
  final List<Telefone> listaTelefone;
  final List<DiaFuncionamento> listaDiaFuncionamento;

  PontoColeta({
    this.id,
    required this.nome,
    this.descricao,
    this.email,
    this.telefone,
    required this.endereco,
    required this.latitude,
    required this.longitude,
    this.imagemBase64,
    this.nomeImagem,
    this.materiais = const [],
    this.listaTelefone = const [],
    this.listaDiaFuncionamento = const [],
  });

  factory PontoColeta.fromJson(Map<String, dynamic> json) {
    String? mainPhone;
    if (json['listaTelefone'] != null && (json['listaTelefone'] as List).isNotEmpty) {
      final firstPhone = json['listaTelefone'][0];
      mainPhone = '(${firstPhone['codigoArea']}) ${firstPhone['numero']}';
    } else if (json['telefone'] != null) {
      mainPhone = json['telefone'];
    }
    
    return PontoColeta(
      id: json['id'],
      nome: json['nome'] ?? '',
      descricao: json['descricao'],
      email: json['email'],
      telefone: mainPhone,
      endereco: json['endereco'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      imagemBase64: json['imagemBase64'],
      nomeImagem: json['nomeImagem'],
      materiais: json['materiais'] != null || json['listaMaterial'] != null
          ? ((json['materiais'] ?? json['listaMaterial']) as List)
              .map((m) => Material.fromJson(m))
              .toList()
          : [],
      listaTelefone: json['listaTelefone'] != null
          ? (json['listaTelefone'] as List)
              .map((t) => Telefone.fromJson(t))
              .toList()
          : [],
      listaDiaFuncionamento: json['listaDiaFuncionamento'] != null
          ? (json['listaDiaFuncionamento'] as List)
              .map((d) => DiaFuncionamento.fromJson(d))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
      'email': email,
      'endereco': endereco,
      'latitude': latitude,
      'longitude': longitude,
      if (imagemBase64 != null) 'imagemBase64': imagemBase64,
      'listaIdMaterial': materiais.map((m) => m.id).toList(),
      'listaTelefone': listaTelefone.map((t) => t.toJson()).toList(),
      'listaDiaFuncionamento':
          listaDiaFuncionamento.map((d) => d.toJson()).toList(),
    };
  }

  String get imageUrl {
    if (nomeImagem != null && nomeImagem!.isNotEmpty) {
      return '${ApiConfig.baseUrl}/pontos-coleta/$id/image/download';
    }
    return '';
  }

  String? get imageSource {
    if (imagemBase64 != null && imagemBase64!.isNotEmpty) {
      return imagemBase64;
    }
    if (nomeImagem != null && nomeImagem!.isNotEmpty) {
      return imageUrl;
    }
    return null;
  }
}
