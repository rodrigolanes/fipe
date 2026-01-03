import '../../domain/entities/mes_referencia_entity.dart';

/// Model para o mês de referência da tabela FIPE
class MesReferenciaModel extends MesReferenciaEntity {
  const MesReferenciaModel({
    required super.id,
    required super.nomeFormatado,
    required super.dataAtualizacao,
  });

  /// Cria um model a partir de JSON
  factory MesReferenciaModel.fromJson(Map<String, dynamic> json) {
    return MesReferenciaModel(
      id: json['id'] as String,
      nomeFormatado: json['nome_formatado'] as String,
      dataAtualizacao: DateTime.parse(json['data_atualizacao'] as String),
    );
  }

  /// Converte o model para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome_formatado': nomeFormatado,
      'data_atualizacao': dataAtualizacao.toIso8601String(),
    };
  }

  /// Cria uma cópia com campos atualizados
  MesReferenciaModel copyWith({
    String? id,
    String? nomeFormatado,
    DateTime? dataAtualizacao,
  }) {
    return MesReferenciaModel(
      id: id ?? this.id,
      nomeFormatado: nomeFormatado ?? this.nomeFormatado,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
    );
  }
}
