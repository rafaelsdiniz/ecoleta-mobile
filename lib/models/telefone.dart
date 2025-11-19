class Telefone {
  final int? id;
  final String numero;
  final String codigoArea;

  Telefone({
    this.id,
    required this.numero,
    required this.codigoArea,
  });

  factory Telefone.fromJson(Map<String, dynamic> json) {
    return Telefone(
      id: json['id'],
      numero: json['numero'] ?? '',
      codigoArea: json['codigoArea'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numero': numero,
      'codigoArea': codigoArea,
    };
  }
}
