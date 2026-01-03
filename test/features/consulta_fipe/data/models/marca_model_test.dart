import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:fipe/features/consulta_fipe/data/models/marca_model.dart';
import 'package:fipe/features/consulta_fipe/domain/entities/marca_entity.dart';

import '../../../../fixtures/marca_fixture.dart';

void main() {
  group('MarcaModel', () {
    test('deve ser uma subclasse de MarcaEntity', () {
      expect(MarcaFixture.marcaModel, isA<MarcaEntity>());
    });

    group('fromJson', () {
      test('deve retornar um MarcaModel válido com todos os campos', () {
        // Arrange
        final Map<String, dynamic> jsonMap =
            MarcaFixture.marcaComEstatisticasJson;

        // Act
        final result = MarcaModel.fromJson(jsonMap);

        // Assert
        expect(result, equals(MarcaFixture.marcaComEstatisticasModel));
        expect(result.id, 1);
        expect(result.nome, 'FIAT');
        expect(result.tipo, 'carro');
        expect(result.totalModelos, 150);
        expect(result.primeiroAno, 1990);
        expect(result.ultimoAno, 2026);
      });

      test('deve retornar um MarcaModel válido sem campos opcionais', () {
        // Arrange
        final Map<String, dynamic> jsonMap = MarcaFixture.marcaJson;

        // Act
        final result = MarcaModel.fromJson(jsonMap);

        // Assert
        expect(result.id, 1);
        expect(result.nome, 'FIAT');
        expect(result.tipo, 'carro');
        expect(result.totalModelos, null);
        expect(result.primeiroAno, null);
        expect(result.ultimoAno, null);
      });

      test('deve funcionar com tipo moto', () {
        // Arrange
        final Map<String, dynamic> jsonMap = MarcaFixture.marcaMotoJson;

        // Act
        final result = MarcaModel.fromJson(jsonMap);

        // Assert
        expect(result.tipo, 'moto');
        expect(result.nome, 'HONDA');
      });
    });

    group('toJson', () {
      test('deve retornar um Map JSON válido com todos os campos', () {
        // Arrange
        const marca = MarcaFixture.marcaComEstatisticasModel;

        // Act
        final result = marca.toJson();

        // Assert
        final expectedMap = {
          'id': 1,
          'nome': 'FIAT',
          'tipo': 'carro',
          'total_modelos': 150,
          'primeiro_ano': 1990,
          'ultimo_ano': 2026,
        };
        expect(result, equals(expectedMap));
      });

      test('deve retornar um Map JSON válido sem campos opcionais', () {
        // Arrange
        const marca = MarcaModel(
          id: 1,
          nome: 'FIAT',
          tipo: 'carro',
        );

        // Act
        final result = marca.toJson();

        // Assert
        expect(result['id'], 1);
        expect(result['nome'], 'FIAT');
        expect(result['tipo'], 'carro');
        expect(result['total_modelos'], null);
        expect(result['primeiro_ano'], null);
        expect(result['ultimo_ano'], null);
      });
    });

    group('fromEntity', () {
      test('deve converter MarcaEntity para MarcaModel', () {
        // Arrange
        const entity = MarcaFixture.marcaEntity;

        // Act
        final result = MarcaModel.fromEntity(entity);

        // Assert
        expect(result, isA<MarcaModel>());
        expect(result.id, entity.id);
        expect(result.nome, entity.nome);
        expect(result.tipo, entity.tipo);
        expect(result.totalModelos, entity.totalModelos);
        expect(result.primeiroAno, entity.primeiroAno);
        expect(result.ultimoAno, entity.ultimoAno);
      });

      test('deve converter MarcaEntity sem campos opcionais', () {
        // Arrange
        const entity = MarcaEntity(
          id: 2,
          nome: 'VOLKSWAGEN',
          tipo: 'carro',
        );

        // Act
        final result = MarcaModel.fromEntity(entity);

        // Assert
        expect(result.id, 2);
        expect(result.nome, 'VOLKSWAGEN');
        expect(result.totalModelos, null);
      });
    });

    group('JSON round-trip', () {
      test('deve manter dados após fromJson e toJson', () {
        // Arrange
        final Map<String, dynamic> originalJson =
            MarcaFixture.marcaComEstatisticasJson;

        // Act
        final model = MarcaModel.fromJson(originalJson);
        final resultJson = model.toJson();

        // Assert
        expect(resultJson, equals(originalJson));
      });
    });
  });
}
