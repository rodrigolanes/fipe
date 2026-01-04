import '../../domain/entities/sync_version_entity.dart';

/// Model para versão de sincronização da base FIPE
class SyncVersionModel extends SyncVersionEntity {
  const SyncVersionModel({
    required super.version,
    required super.mesReferencia,
    required super.dataAtualizacao,
    super.totalMarcas,
    super.totalModelos,
    super.totalValores,
    super.cargaConcluida,
  });

  /// Cria um model a partir de JSON do Supabase
  factory SyncVersionModel.fromJson(Map<String, dynamic> json) {
    return SyncVersionModel(
      version: json['version'] as String,
      mesReferencia: json['mes_referencia'] as String,
      dataAtualizacao: DateTime.parse(json['data_atualizacao'] as String),
      totalMarcas: (json['total_marcas'] as int?) ?? 0,
      totalModelos: (json['total_modelos'] as int?) ?? 0,
      totalValores: (json['total_valores'] as int?) ?? 0,
      cargaConcluida: (json['carga_concluida'] as bool?) ?? false,
    );
  }

  /// Converte o model para JSON
  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'mes_referencia': mesReferencia,
      'data_atualizacao': dataAtualizacao.toIso8601String(),
      'total_marcas': totalMarcas,
      'total_modelos': totalModelos,
      'total_valores': totalValores,
      'carga_concluida': cargaConcluida,
    };
  }

  /// Cria uma cópia com campos atualizados
  SyncVersionModel copyWith({
    String? version,
    String? mesReferencia,
    DateTime? dataAtualizacao,
    int? totalMarcas,
    int? totalModelos,
    int? totalValores,
    bool? cargaConcluida,
  }) {
    return SyncVersionModel(
      version: version ?? this.version,
      mesReferencia: mesReferencia ?? this.mesReferencia,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      totalMarcas: totalMarcas ?? this.totalMarcas,
      totalModelos: totalModelos ?? this.totalModelos,
      totalValores: totalValores ?? this.totalValores,
      cargaConcluida: cargaConcluida ?? this.cargaConcluida,
    );
  }
}
