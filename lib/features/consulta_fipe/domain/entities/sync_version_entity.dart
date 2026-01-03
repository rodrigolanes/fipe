import 'package:equatable/equatable.dart';

/// Entidade que representa a versão de sincronização da base FIPE
///
/// Controla qual versão dos dados está armazenada localmente
/// e permite verificar se há atualizações disponíveis no servidor.
class SyncVersionEntity extends Equatable {
  /// Versão no formato YYYYMM (ex: "202601")
  final String version;

  /// Nome formatado do mês (ex: "Janeiro/2026")
  final String mesReferencia;

  /// Data da última atualização
  final DateTime dataAtualizacao;

  /// Total de marcas sincronizadas
  final int totalMarcas;

  /// Total de modelos sincronizados
  final int totalModelos;

  /// Total de valores FIPE sincronizados
  final int totalValores;

  const SyncVersionEntity({
    required this.version,
    required this.mesReferencia,
    required this.dataAtualizacao,
    this.totalMarcas = 0,
    this.totalModelos = 0,
    this.totalValores = 0,
  });

  @override
  List<Object?> get props => [
        version,
        mesReferencia,
        dataAtualizacao,
        totalMarcas,
        totalModelos,
        totalValores,
      ];

  /// Verifica se esta versão é mais recente que outra
  bool isNewerThan(SyncVersionEntity other) {
    return version.compareTo(other.version) > 0;
  }

  /// Verifica se é a mesma versão
  bool isSameVersion(SyncVersionEntity other) {
    return version == other.version;
  }
}
