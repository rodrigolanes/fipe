import 'package:hive/hive.dart';

import '../../domain/entities/modelo_entity.dart';

part 'modelo_model.g.dart';

@HiveType(typeId: 1)
class ModeloModel extends ModeloEntity {
  @HiveField(0)
  @override
  final int id;

  @HiveField(1)
  @override
  final int marcaId;

  @HiveField(2)
  @override
  final String nome;

  @HiveField(3)
  @override
  final String tipo;

  const ModeloModel({
    required this.id,
    required this.marcaId,
    required this.nome,
    required this.tipo,
  }) : super(id: id, marcaId: marcaId, nome: nome, tipo: tipo);

  /// Cria um ModeloModel a partir de JSON
  factory ModeloModel.fromJson(Map<String, dynamic> json) {
    return ModeloModel(
      id: json['id'] as int,
      marcaId: json['marca_id'] as int,
      nome: json['nome'] as String,
      tipo: json['tipo'] as String,
    );
  }

  /// Converte ModeloModel para JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'marca_id': marcaId, 'nome': nome, 'tipo': tipo};
  }

  /// Converte Entity para Model
  factory ModeloModel.fromEntity(ModeloEntity entity) {
    return ModeloModel(
      id: entity.id,
      marcaId: entity.marcaId,
      nome: entity.nome,
      tipo: entity.tipo,
    );
  }
}
