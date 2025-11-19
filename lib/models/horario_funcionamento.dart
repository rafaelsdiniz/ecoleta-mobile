import 'enums.dart';

class HorarioFuncionamento {
  final int? id;
  final String horarioInicial;
  final String horarioFinal;
  final Disponibilidade disponibilidade;

  HorarioFuncionamento({
    this.id,
    required this.horarioInicial,
    required this.horarioFinal,
    required this.disponibilidade,
  });

  factory HorarioFuncionamento.fromJson(Map<String, dynamic> json) {
    return HorarioFuncionamento(
      id: json['id'],
      horarioInicial: json['horarioInicial'] ?? '',
      horarioFinal: json['horarioFinal'] ?? '',
      disponibilidade: json['disponibilidade'] != null
          ? Disponibilidade.values.firstWhere(
              (e) => e.name == json['disponibilidade'],
              orElse: () => Disponibilidade.AUTO_ATENDIMENTO,
            )
          : Disponibilidade.AUTO_ATENDIMENTO,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'horarioInicial': horarioInicial,
      'horarioFinal': horarioFinal,
      'disponibilidade': disponibilidade.name,
    };
  }
}
