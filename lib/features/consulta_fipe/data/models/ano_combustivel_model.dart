import '../../domain/entities/ano_combustivel_entity.dart';

class AnoCombustivelModel extends AnoCombustivelEntity {
  @override
  final String ano;

  @override
  final String combustivel;

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
