import 'package:flutter_test/flutter_test.dart';

import 'package:fipe/features/consulta_fipe/data/models/valor_fipe_model.dart';
import 'package:fipe/features/consulta_fipe/domain/entities/valor_fipe_entity.dart';

import '../../../../fixtures/valor_fipe_fixture.dart';

void main() {
  group('ValorFipeModel', () {
    test('deve ser uma subclasse de ValorFipeEntity', () {
      expect(ValorFipeFixture.valorFipeModel, isA<ValorFipeEntity>());
    });

    group('fromJson', () {
      test('deve retornar um ValorFipeModel válido', () {
        // Arrange
        final Map<String, dynamic> jsonMap = ValorFipeFixture.valorFipeJson;

        // Act
        final result = ValorFipeModel.fromJson(jsonMap);

        // Assert
        expect(result.marca, 'FIAT');
        expect(result.modelo, 'PALIO 1.0');
        expect(result.anoModelo, 2024);
        expect(result.combustivel, 'Gasolina');
        expect(result.codigoFipe, '001234-5');
        expect(result.mesReferencia, '202601');
        expect(result.valor, 'R\$ 45.000,00');
        expect(result.dataConsulta, DateTime(2026, 1, 2, 10, 30));
      });

      test('deve funcionar com ano Zero KM (32000)', () {
        // Arrange
        final Map<String, dynamic> jsonMap =
            ValorFipeFixture.valorFipeZeroKmJson;

        // Act
        final result = ValorFipeModel.fromJson(jsonMap);

        // Assert
        expect(result.anoModelo, 32000);
        expect(result.modelo, 'ARGO 1.0');
      });

      test('deve parsear DateTime corretamente do ISO8601', () {
        // Arrange
        final Map<String, dynamic> jsonMap = ValorFipeFixture.valorFipeJson;

        // Act
        final result = ValorFipeModel.fromJson(jsonMap);

        // Assert
        expect(result.dataConsulta.year, 2026);
        expect(result.dataConsulta.month, 1);
        expect(result.dataConsulta.day, 2);
        expect(result.dataConsulta.hour, 10);
        expect(result.dataConsulta.minute, 30);
        expect(result.dataConsulta.second, 0);
      });

      test('deve usar DateTime.now() se data_consulta for null', () {
        // Arrange
        final jsonMap = <String, dynamic>{
          'marca': 'FIAT',
          'modelo': 'PALIO 1.0',
          'ano_modelo': 2024,
          'combustivel': 'Gasolina',
          'codigo_fipe': '001234-5',
          'mes_referencia': '202601',
          'valor': 'R\$ 45.000,00',
        };

        // Act
        final result = ValorFipeModel.fromJson(jsonMap);
        final now = DateTime.now();

        // Assert
        expect(result.dataConsulta.year, now.year);
        expect(result.dataConsulta.month, now.month);
        expect(result.dataConsulta.day, now.day);
      });
    });

    group('toJson', () {
      test('deve retornar um Map JSON válido', () {
        // Arrange
        final valorFipe = ValorFipeFixture.valorFipeModel;

        // Act
        final result = valorFipe.toJson();

        // Assert
        expect(result['marca'], 'FIAT');
        expect(result['modelo'], 'PALIO 1.0');
        expect(result['ano_modelo'], 2024);
        expect(result['combustivel'], 'Gasolina');
        expect(result['codigo_fipe'], '001234-5');
        expect(result['mes_referencia'], '202601');
        expect(result['valor'], 'R\$ 45.000,00');
        expect(result['data_consulta'], '2026-01-02T10:30:00.000');
      });

      test('deve usar snake_case para todos os campos', () {
        // Arrange
        final valorFipe = ValorFipeFixture.valorFipeModel;

        // Act
        final result = valorFipe.toJson();

        // Assert
        expect(result.containsKey('ano_modelo'), true);
        expect(result.containsKey('codigo_fipe'), true);
        expect(result.containsKey('mes_referencia'), true);
        expect(result.containsKey('data_consulta'), true);
        expect(result.containsKey('anoModelo'), false);
        expect(result.containsKey('codigoFipe'), false);
      });

      test('deve converter DateTime para ISO8601 string', () {
        // Arrange
        final valorFipe = ValorFipeModel(
          marca: 'FIAT',
          modelo: 'PALIO 1.0',
          anoModelo: 2024,
          combustivel: 'Gasolina',
          codigoFipe: '001234-5',
          mesReferencia: '202601',
          valor: 'R\$ 45.000,00',
          dataConsulta: DateTime(2026, 1, 2, 15, 45, 30),
        );

        // Act
        final result = valorFipe.toJson();

        // Assert
        expect(result['data_consulta'], '2026-01-02T15:45:30.000');
      });
    });

    group('fromEntity', () {
      test('deve converter ValorFipeEntity para ValorFipeModel', () {
        // Arrange
        final entity = ValorFipeFixture.valorFipeEntity;

        // Act
        final result = ValorFipeModel.fromEntity(entity);

        // Assert
        expect(result, isA<ValorFipeModel>());
        expect(result.marca, entity.marca);
        expect(result.modelo, entity.modelo);
        expect(result.anoModelo, entity.anoModelo);
        expect(result.combustivel, entity.combustivel);
        expect(result.codigoFipe, entity.codigoFipe);
        expect(result.mesReferencia, entity.mesReferencia);
        expect(result.valor, entity.valor);
        expect(result.dataConsulta, entity.dataConsulta);
      });

      test('deve preservar todos os campos na conversão', () {
        // Arrange
        final entity = ValorFipeEntity(
          marca: 'BMW',
          modelo: 'X5 3.0',
          anoModelo: 2024,
          combustivel: 'Diesel',
          codigoFipe: '999999-9',
          mesReferencia: '202601',
          valor: 'R\$ 650.000,00',
          dataConsulta: DateTime(2026, 1, 1),
        );

        // Act
        final result = ValorFipeModel.fromEntity(entity);

        // Assert
        expect(result.marca, 'BMW');
        expect(result.valor, 'R\$ 650.000,00');
        expect(result.anoModelo, 2024);
      });
    });

    group('JSON round-trip', () {
      test('deve manter dados após fromJson e toJson', () {
        // Arrange
        final Map<String, dynamic> originalJson =
            ValorFipeFixture.valorFipeJson;

        // Act
        final model = ValorFipeModel.fromJson(originalJson);
        final resultJson = model.toJson();

        // Assert
        expect(resultJson['marca'], originalJson['marca']);
        expect(resultJson['modelo'], originalJson['modelo']);
        expect(resultJson['ano_modelo'], originalJson['ano_modelo']);
        expect(resultJson['combustivel'], originalJson['combustivel']);
        expect(resultJson['codigo_fipe'], originalJson['codigo_fipe']);
        expect(resultJson['mes_referencia'], originalJson['mes_referencia']);
        expect(resultJson['valor'], originalJson['valor']);
        // DateTime ISO8601 mantém o mesmo momento no tempo
        expect(
          DateTime.parse(resultJson['data_consulta']),
          DateTime.parse(originalJson['data_consulta']),
        );
      });
    });
  });
}
