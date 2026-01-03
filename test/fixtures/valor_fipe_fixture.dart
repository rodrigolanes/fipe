import 'package:fipe/features/consulta_fipe/data/models/valor_fipe_model.dart';
import 'package:fipe/features/consulta_fipe/domain/entities/valor_fipe_entity.dart';

/// Fixtures de teste para ValorFipe
class ValorFipeFixture {
  /// Data fixa para testes
  static final DateTime dataConsulta = DateTime(2026, 1, 2, 10, 30);

  /// JSON de valor FIPE
  static Map<String, dynamic> get valorFipeJson => {
        'marca': 'FIAT',
        'modelo': 'PALIO 1.0',
        'ano_modelo': 2024,
        'combustivel': 'Gasolina',
        'codigo_fipe': '001234-5',
        'mes_referencia': '202601',
        'valor': 'R\$ 45.000,00',
        'data_consulta': dataConsulta.toIso8601String(),
      };

  /// JSON de valor FIPE Zero KM
  static Map<String, dynamic> get valorFipeZeroKmJson => {
        'marca': 'FIAT',
        'modelo': 'ARGO 1.0',
        'ano_modelo': 32000,
        'combustivel': 'Flex',
        'codigo_fipe': '001235-6',
        'mes_referencia': '202601',
        'valor': 'R\$ 68.500,00',
        'data_consulta': dataConsulta.toIso8601String(),
      };

  /// JSON com valor alto
  static Map<String, dynamic> get valorFipeAltoJson => {
        'marca': 'BMW',
        'modelo': 'X5 3.0',
        'ano_modelo': 2024,
        'combustivel': 'Diesel',
        'codigo_fipe': '999999-9',
        'mes_referencia': '202601',
        'valor': 'R\$ 650.000,00',
        'data_consulta': dataConsulta.toIso8601String(),
      };

  /// Model de valor FIPE
  static final ValorFipeModel valorFipeModel = ValorFipeModel(
    marca: 'FIAT',
    modelo: 'PALIO 1.0',
    anoModelo: 2024,
    combustivel: 'Gasolina',
    codigoFipe: '001234-5',
    mesReferencia: '202601',
    valor: 'R\$ 45.000,00',
    dataConsulta: dataConsulta,
  );

  /// Model de valor FIPE Zero KM
  static final ValorFipeModel valorFipeZeroKmModel = ValorFipeModel(
    marca: 'FIAT',
    modelo: 'ARGO 1.0',
    anoModelo: 32000,
    combustivel: 'Flex',
    codigoFipe: '001235-6',
    mesReferencia: '202601',
    valor: 'R\$ 68.500,00',
    dataConsulta: dataConsulta,
  );

  /// Entity de valor FIPE
  static final ValorFipeEntity valorFipeEntity = ValorFipeEntity(
    marca: 'FIAT',
    modelo: 'PALIO 1.0',
    anoModelo: 2024,
    combustivel: 'Gasolina',
    codigoFipe: '001234-5',
    mesReferencia: '202601',
    valor: 'R\$ 45.000,00',
    dataConsulta: dataConsulta,
  );

  /// Entity de valor FIPE Zero KM
  static final ValorFipeEntity valorFipeZeroKmEntity = ValorFipeEntity(
    marca: 'FIAT',
    modelo: 'ARGO 1.0',
    anoModelo: 32000,
    combustivel: 'Flex',
    codigoFipe: '001235-6',
    mesReferencia: '202601',
    valor: 'R\$ 68.500,00',
    dataConsulta: dataConsulta,
  );
}
