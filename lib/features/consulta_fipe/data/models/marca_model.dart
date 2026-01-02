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

  @HiveField(3)
  @override
  final int? totalModelos;

  @HiveField(4)
  @override
  final int? primeiroAno;

  @HiveField(5)
  @override
  final int? ultimoAno;

  const MarcaModel({
    required this.id,
    required this.nome,
    required this.tipo,
    this.totalModelos,
    this.primeiroAno,
    this.ultimoAno,
  }) : super(
          id: id,
          nome: nome,
          tipo: tipo,
          totalModelos: totalModelos,
          primeiroAno: primeiroAno,
          ultimoAno: ultimoAno,
        );

  /// Cria um MarcaModel a partir de JSON
  factory MarcaModel.fromJson(Map<String, dynamic> json) {
    return MarcaModel(
      id: json['id'] as int,
      nome: json['nome'] as String,
      tipo: json['tipo'] as String,
      totalModelos: json['total_modelos'] as int?,
      primeiroAno: json['primeiro_ano'] as int?,
      ultimoAno: json['ultimo_ano'] as int?,
    );
  }

  /// Converte MarcaModel para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'total_modelos': totalModelos,
      'primeiro_ano': primeiroAno,
      'ultimo_ano': ultimoAno,
    };
  }

  /// Converte Entity para Model
  factory MarcaModel.fromEntity(MarcaEntity entity) {
    return MarcaModel(
      id: entity.id,
      nome: entity.nome,
      tipo: entity.tipo,
      totalModelos: entity.totalModelos,
      primeiroAno: entity.primeiroAno,
      ultimoAno: entity.ultimoAno,
    );
  }
}
