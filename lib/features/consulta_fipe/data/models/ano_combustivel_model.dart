import 'package:hive/hive.dart';

import '../../domain/entities/ano_combustivel_entity.dart';

part 'ano_combustivel_model.g.dart';

@HiveType(typeId: 2)
class AnoCombustivelModel extends AnoCombustivelEntity {
  @HiveField(0)
  @override
  final String ano;

  @HiveField(1)
  @override
  final String combustivel;

  @HiveField(2)
  @override
  final String codigoFipe;

  const AnoCombustivelModel({
    required this.ano,
    required this.combustivel,
    required this.codigoFipe,
  }) : super(ano: ano, combustivel: combustivel, codigoFipe: codigoFipe);

  /// Cria um AnoCombustivelModel a partir de JSON
  factory AnoCombustivelModel.fromJson(Map<String, dynamic> json) {
    return AnoCombustivelModel(
      ano: json['ano'] as String,
      combustivel: json['combustivel'] as String,
      codigoFipe: json['codigo_fipe'] as String,
    );
  }

  /// Converte AnoCombustivelModel para JSON
  Map<String, dynamic> toJson() {
    return {
      'ano': ano,
      'combustivel': combustivel,
      'codigo_fipe': codigoFipe,
    };
  }

  /// Converte Entity para Model
  factory AnoCombustivelModel.fromEntity(AnoCombustivelEntity entity) {
    return AnoCombustivelModel(
      ano: entity.ano,
      combustivel: entity.combustivel,
      codigoFipe: entity.codigoFipe,
    );
  }
}
