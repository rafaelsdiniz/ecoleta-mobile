import 'enums.dart';
import 'horario_funcionamento.dart';

class DiaFuncionamento {
  final int? id;
  final DiaSemana diaSemana;
  final List<HorarioFuncionamento> listaHorarioFuncionamento;

  DiaFuncionamento({
    this.id,
    required this.diaSemana,
    this.listaHorarioFuncionamento = const [],
  });

  factory DiaFuncionamento.fromJson(Map<String, dynamic> json) {
    return DiaFuncionamento(
      id: json['id'],
      diaSemana: json['diaSemana'] != null
          ? DiaSemana.values.firstWhere(
              (e) => e.name == json['diaSemana'],
              orElse: () => DiaSemana.SEGUNDA,
            )
          : DiaSemana.SEGUNDA,
      listaHorarioFuncionamento: json['listaHorarioFuncionamento'] != null
          ? (json['listaHorarioFuncionamento'] as List)
              .map((h) => HorarioFuncionamento.fromJson(h))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diaSemana': diaSemana.name,
      'listaHorarioFuncionamento':
          listaHorarioFuncionamento.map((h) => h.toJson()).toList(),
    };
  }
}
