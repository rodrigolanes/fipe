import 'package:hive/hive.dart';

import '../../domain/entities/valor_fipe_entity.dart';

part 'valor_fipe_model.g.dart';

@HiveType(typeId: 3)
class ValorFipeModel extends ValorFipeEntity {
  @HiveField(0)
  @override
  final String marca;

  @HiveField(1)
  @override
  final String modelo;

  @HiveField(2)
  @override
  final int anoModelo;

  @HiveField(3)
  @override
  final String combustivel;

  @HiveField(4)
  @override
  final String codigoFipe;

  @HiveField(5)
  @override
  final String mesReferencia;

  @HiveField(6)
  @override
  final String valor;

  @HiveField(7)
  @override
  final DateTime dataConsulta;

  @HiveField(8)
  final int? tipoVeiculo;

  @HiveField(9)
  final int? codigoMarca;

  @HiveField(10)
  final int? codigoModelo;

  @HiveField(11)
  final int? codigoCombustivel;

  const ValorFipeModel({
    required this.marca,
    required this.modelo,
    required this.anoModelo,
    required this.combustivel,
    required this.codigoFipe,
    required this.mesReferencia,
    required this.valor,
    required this.dataConsulta,
    this.tipoVeiculo,
    this.codigoMarca,
    this.codigoModelo,
    this.codigoCombustivel,
  }) : super(
          marca: marca,
          modelo: modelo,
          anoModelo: anoModelo,
          combustivel: combustivel,
          codigoFipe: codigoFipe,
          mesReferencia: mesReferencia,
          valor: valor,
          dataConsulta: dataConsulta,
        );

  /// Cria um ValorFipeModel a partir de JSON
  factory ValorFipeModel.fromJson(Map<String, dynamic> json) {
    return ValorFipeModel(
      marca: json['marca'] as String,
      modelo: json['modelo'] as String,
      anoModelo: json['ano_modelo'] as int,
      combustivel: json['combustivel'] as String,
      codigoFipe: json['codigo_fipe'] as String,
      mesReferencia: json['mes_referencia'] as String,
      valor: json['valor'] as String,
      dataConsulta: json['data_consulta'] != null
          ? DateTime.parse(json['data_consulta'] as String)
          : DateTime.now(),
      tipoVeiculo: json['tipo_veiculo'] as int?,
      codigoMarca: json['codigo_marca'] != null
          ? int.tryParse(json['codigo_marca'].toString())
          : null,
      codigoModelo: json['codigo_modelo'] as int?,
      codigoCombustivel: json['codigo_combustivel'] as int?,
    );
  }

  /// Converte ValorFipeModel para JSON
  Map<String, dynamic> toJson() {
    return {
      'marca': marca,
      'modelo': modelo,
      'ano_modelo': anoModelo,
      'combustivel': combustivel,
      'codigo_fipe': codigoFipe,
      'mes_referencia': mesReferencia,
      'valor': valor,
      'data_consulta': dataConsulta.toIso8601String(),
      if (tipoVeiculo != null) 'tipo_veiculo': tipoVeiculo,
      if (codigoMarca != null) 'codigo_marca': codigoMarca,
      if (codigoModelo != null) 'codigo_modelo': codigoModelo,
      if (codigoCombustivel != null) 'codigo_combustivel': codigoCombustivel,
    };
  }

  /// Converte Entity para Model
  factory ValorFipeModel.fromEntity(ValorFipeEntity entity) {
    return ValorFipeModel(
      marca: entity.marca,
      modelo: entity.modelo,
      anoModelo: entity.anoModelo,
      combustivel: entity.combustivel,
      codigoFipe: entity.codigoFipe,
      mesReferencia: entity.mesReferencia,
      valor: entity.valor,
      dataConsulta: entity.dataConsulta,
    );
  }
}
