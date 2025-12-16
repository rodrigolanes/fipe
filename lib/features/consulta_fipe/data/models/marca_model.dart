import 'package:hive/hive.dart';

import '../../domain/entities/marca_entity.dart';

part 'marca_model.g.dart';

@HiveType(typeId: 0)
class MarcaModel extends MarcaEntity {
  @HiveField(0)
  @override
  final int id;

  @HiveField(1)
  @override
  final String nome;

  @HiveField(2)
  @override
  final String tipo;

  const MarcaModel({required this.id, required this.nome, required this.tipo})
    : super(id: id, nome: nome, tipo: tipo);

  /// Cria um MarcaModel a partir de JSON
  factory MarcaModel.fromJson(Map<String, dynamic> json) {
    return MarcaModel(
      id: json['id'] as int,
      nome: json['nome'] as String,
      tipo: json['tipo'] as String,
    );
  }

  /// Converte MarcaModel para JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome, 'tipo': tipo};
  }

  /// Converte Entity para Model
  factory MarcaModel.fromEntity(MarcaEntity entity) {
    return MarcaModel(id: entity.id, nome: entity.nome, tipo: entity.tipo);
  }
}
