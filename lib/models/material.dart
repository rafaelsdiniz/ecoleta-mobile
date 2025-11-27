import '../config/api_config.dart';

class Material {
  final int? id;
  final String nome;
  final String? imagemBase64;
  final String? nomeImagem;

  Material({
    this.id,
    required this.nome,
    this.imagemBase64,
    this.nomeImagem,
  });

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['id'],
      nome: json['nome'] ?? '',
      imagemBase64: json['imagemBase64'],
      nomeImagem: json['nomeImagem'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      if (imagemBase64 != null) 'imagemBase64': imagemBase64,
    };
  }

  String get imageUrl {
    if (nomeImagem != null && nomeImagem!.isNotEmpty) {
      return '${ApiConfig.baseUrl}/materiais/$id/image/download';
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
