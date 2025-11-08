// Enums que correspondem exatamente aos enums da API Quarkus

enum DiaSemana {
  SEGUNDA,
  TERCA,
  QUARTA,
  QUINTA,
  SEXTA,
  SABADO,
  DOMINGO;

  String get displayName {
    switch (this) {
      case DiaSemana.SEGUNDA:
        return 'Segunda-feira';
      case DiaSemana.TERCA:
        return 'Terça-feira';
      case DiaSemana.QUARTA:
        return 'Quarta-feira';
      case DiaSemana.QUINTA:
        return 'Quinta-feira';
      case DiaSemana.SEXTA:
        return 'Sexta-feira';
      case DiaSemana.SABADO:
        return 'Sábado';
      case DiaSemana.DOMINGO:
        return 'Domingo';
    }
  }
}

enum Disponibilidade {
  AUTO_ATENDIMENTO,
  APENAS_COM_PROFISSIONAL;

  String get displayName {
    switch (this) {
      case Disponibilidade.AUTO_ATENDIMENTO:
        return 'Auto Atendimento';
      case Disponibilidade.APENAS_COM_PROFISSIONAL:
        return 'Apenas com Profissional';
    }
  }
}

enum Remetente {
  USUARIO,
  PONTO_COLETA,
  ADM;
}

enum TipoUsuario {
  ADMIN,
  CLIENTE;

  String get displayName {
    switch (this) {
      case TipoUsuario.ADMIN:
        return 'Administrador';
      case TipoUsuario.CLIENTE:
        return 'Cliente';
    }
  }
}
