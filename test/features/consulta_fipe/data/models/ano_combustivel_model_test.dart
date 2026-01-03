import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:fipe/features/consulta_fipe/data/models/ano_combustivel_model.dart';
import 'package:fipe/features/consulta_fipe/domain/entities/ano_combustivel_entity.dart';

import '../../../../fixtures/ano_combustivel_fixture.dart';

void main() {
  group('AnoCombustivelModel', () {
    test('deve ser uma subclasse de AnoCombustivelEntity', () {
      expect(
        AnoCombustivelFixture.anoCombustivelModel,
        isA<AnoCombustivelEntity>(),
      );
    });

    group('fromJson', () {
      test('deve retornar um AnoCombustivelModel válido', () {
        // Arrange
        final Map<String, dynamic> jsonMap =
            AnoCombustivelFixture.anoCombustivelJson;

        // Act
        final result = AnoCombustivelModel.fromJson(jsonMap);

        // Assert
        expect(result, equals(AnoCombustivelFixture.anoCombustivelModel));
        expect(result.ano, '2024');
        expect(result.combustivel, 'Gasolina');
        expect(result.codigoFipe, '001234-5');
      });

      test('deve funcionar com ano Zero KM', () {
        // Arrange
        final Map<String, dynamic> jsonMap = AnoCombustivelFixture.zeroKmJson;

        // Act
        final result = AnoCombustivelModel.fromJson(jsonMap);

        // Assert
        expect(result.ano, '32000');
        expect(result.combustivel, 'Gasolina');
      });

      test('deve usar snake_case para codigo_fipe no JSON', () {
        // Arrange
        final Map<String, dynamic> jsonMap = AnoCombustivelFixture.dieselJson;

        // Act
        final result = AnoCombustivelModel.fromJson(jsonMap);

        // Assert
        expect(result.codigoFipe, '001232-3');
      });

      test('deve funcionar com diferentes combustíveis', () {
        // Arrange
        final mapGasolina = AnoCombustivelFixture.anoCombustivelJson;
        final mapFlex = AnoCombustivelFixture.flexJson;
        final mapDiesel = AnoCombustivelFixture.dieselJson;

        // Act & Assert
        expect(
            AnoCombustivelModel.fromJson(mapGasolina).combustivel, 'Gasolina');
        expect(AnoCombustivelModel.fromJson(mapFlex).combustivel, 'Flex');
        expect(AnoCombustivelModel.fromJson(mapDiesel).combustivel, 'Diesel');
      });
    });

    group('toJson', () {
      test('deve retornar um Map JSON válido', () {
        // Arrange
        const anoCombustivel = AnoCombustivelFixture.anoCombustivelModel;

        // Act
        final result = anoCombustivel.toJson();

        // Assert
        final expectedMap = {
          'ano': '2024',
          'combustivel': 'Gasolina',
          'codigo_fipe': '001234-5',
        };
        expect(result, equals(expectedMap));
      });

      test('deve usar snake_case para codigo_fipe', () {
        // Arrange
        const anoCombustivel = AnoCombustivelFixture.anoCombustivelModel;

        // Act
        final result = anoCombustivel.toJson();

        // Assert
        expect(result.containsKey('codigo_fipe'), true);
        expect(result.containsKey('codigoFipe'), false);
      });
    });

    group('fromEntity', () {
      test('deve converter AnoCombustivelEntity para AnoCombustivelModel', () {
        // Arrange
        const entity = AnoCombustivelFixture.anoCombustivelEntity;

        // Act
        final result = AnoCombustivelModel.fromEntity(entity);

        // Assert
        expect(result, isA<AnoCombustivelModel>());
        expect(result.ano, entity.ano);
        expect(result.combustivel, entity.combustivel);
        expect(result.codigoFipe, entity.codigoFipe);
      });

      test('deve preservar código FIPE na conversão', () {
        // Arrange
        const entity = AnoCombustivelEntity(
          ano: '2023',
          combustivel: 'Flex',
          codigoFipe: '888888-8',
        );

        // Act
        final result = AnoCombustivelModel.fromEntity(entity);

        // Assert
        expect(result.codigoFipe, '888888-8');
      });
    });

    group('JSON round-trip', () {
      test('deve manter dados após fromJson e toJson', () {
        // Arrange
        final Map<String, dynamic> originalJson =
            AnoCombustivelFixture.anoCombustivelJson;

        // Act
        final model = AnoCombustivelModel.fromJson(originalJson);
        final resultJson = model.toJson();

        // Assert
        expect(resultJson, equals(originalJson));
      });
    });
  });
}
