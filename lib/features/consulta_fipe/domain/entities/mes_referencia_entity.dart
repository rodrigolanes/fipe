import 'package:equatable/equatable.dart';

/// Entidade que representa o mês de referência da tabela FIPE
///
/// Esta entidade armazena informações sobre o período de referência
/// dos dados FIPE armazenados localmente.
class MesReferenciaEntity extends Equatable {
  /// Identificador no formato YYYYMM (ex: "202601" para Janeiro/2026)
  final String id;

  /// Nome formatado do mês (ex: "janeiro de 2026")
  final String nomeFormatado;

  /// Timestamp da última atualização
  final DateTime dataAtualizacao;

  const MesReferenciaEntity({
    required this.id,
    required this.nomeFormatado,
    required this.dataAtualizacao,
  });

  @override
  List<Object?> get props => [id, nomeFormatado, dataAtualizacao];

  /// Compara se este mês de referência é mais recente que outro
  bool isNewerThan(MesReferenciaEntity other) {
    return id.compareTo(other.id) > 0;
  }

  /// Retorna o ano (YYYY)
  int get ano => int.parse(id.substring(0, 4));

  /// Retorna o mês (MM)
  int get mes => int.parse(id.substring(4, 6));
}
