import 'package:fipe/features/consulta_fipe/data/models/ano_combustivel_model.dart';
import 'package:fipe/features/consulta_fipe/domain/entities/ano_combustivel_entity.dart';

/// Fixtures de teste para AnoCombustivel
class AnoCombustivelFixture {
  /// JSON de ano/combustível normal
  static Map<String, dynamic> get anoCombustivelJson => {
        'ano': '2024',
        'combustivel': 'Gasolina',
        'codigo_fipe': '001234-5',
      };

  /// JSON de Zero KM
  static Map<String, dynamic> get zeroKmJson => {
        'ano': '32000',
        'combustivel': 'Gasolina',
        'codigo_fipe': '001235-6',
      };

  /// JSON com combustível flex
  static Map<String, dynamic> get flexJson => {
        'ano': '2023',
        'combustivel': 'Flex',
        'codigo_fipe': '001233-4',
      };

  /// JSON com diesel
  static Map<String, dynamic> get dieselJson => {
        'ano': '2022',
        'combustivel': 'Diesel',
        'codigo_fipe': '001232-3',
      };

  /// Lista de JSONs de anos/combustíveis
  static List<Map<String, dynamic>> get anosCombustiveisListJson => [
        {
          'ano': '32000',
          'combustivel': 'Gasolina',
          'codigo_fipe': '001235-6',
        },
        {
          'ano': '2024',
          'combustivel': 'Gasolina',
          'codigo_fipe': '001234-5',
        },
        {
          'ano': '2023',
          'combustivel': 'Gasolina',
          'codigo_fipe': '001233-4',
        },
        {
          'ano': '2022',
          'combustivel': 'Flex',
          'codigo_fipe': '001232-3',
        },
      ];

  /// Model de ano/combustível
  static const AnoCombustivelModel anoCombustivelModel = AnoCombustivelModel(
    ano: '2024',
    combustivel: 'Gasolina',
    codigoFipe: '001234-5',
  );

  /// Model Zero KM
  static const AnoCombustivelModel zeroKmModel = AnoCombustivelModel(
    ano: '32000',
    combustivel: 'Gasolina',
    codigoFipe: '001235-6',
  );

  /// Entity de ano/combustível
  static const AnoCombustivelEntity anoCombustivelEntity = AnoCombustivelEntity(
    ano: '2024',
    combustivel: 'Gasolina',
    codigoFipe: '001234-5',
  );

  /// Entity Zero KM
  static const AnoCombustivelEntity zeroKmEntity = AnoCombustivelEntity(
    ano: '32000',
    combustivel: 'Gasolina',
    codigoFipe: '001235-6',
  );

  /// Lista de models
  static const List<AnoCombustivelModel> anosCombustiveisModelList = [
    AnoCombustivelModel(
        ano: '32000', combustivel: 'Gasolina', codigoFipe: '001235-6'),
    AnoCombustivelModel(
        ano: '2024', combustivel: 'Gasolina', codigoFipe: '001234-5'),
    AnoCombustivelModel(
        ano: '2023', combustivel: 'Gasolina', codigoFipe: '001233-4'),
    AnoCombustivelModel(
        ano: '2022', combustivel: 'Flex', codigoFipe: '001232-3'),
  ];

  /// Lista de entities
  static const List<AnoCombustivelEntity> anosCombustiveisEntityList = [
    AnoCombustivelEntity(
        ano: '32000', combustivel: 'Gasolina', codigoFipe: '001235-6'),
    AnoCombustivelEntity(
        ano: '2024', combustivel: 'Gasolina', codigoFipe: '001234-5'),
    AnoCombustivelEntity(
        ano: '2023', combustivel: 'Gasolina', codigoFipe: '001233-4'),
    AnoCombustivelEntity(
        ano: '2022', combustivel: 'Flex', codigoFipe: '001232-3'),
  ];
}
