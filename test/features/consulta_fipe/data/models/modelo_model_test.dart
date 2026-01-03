import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:fipe/features/consulta_fipe/data/models/modelo_model.dart';
import 'package:fipe/features/consulta_fipe/domain/entities/modelo_entity.dart';

import '../../../../fixtures/modelo_fixture.dart';

void main() {
  group('ModeloModel', () {
    test('deve ser uma subclasse de ModeloEntity', () {
      expect(ModeloFixture.modeloModel, isA<ModeloEntity>());
    });

    group('fromJson', () {
      test('deve retornar um ModeloModel válido', () {
        // Arrange
        final Map<String, dynamic> jsonMap = ModeloFixture.modeloJson;

        // Act
        final result = ModeloModel.fromJson(jsonMap);

        // Assert
        expect(result, equals(ModeloFixture.modeloModel));
        expect(result.id, 100);
        expect(result.marcaId, 1);
        expect(result.nome, 'PALIO 1.0');
        expect(result.tipo, 'carro');
      });

      test('deve funcionar com tipo moto', () {
        // Arrange
        final Map<String, dynamic> jsonMap = ModeloFixture.modeloMotoJson;

        // Act
        final result = ModeloModel.fromJson(jsonMap);

        // Assert
        expect(result.id, 200);
        expect(result.marcaId, 10);
        expect(result.nome, 'CG 160 FAN');
        expect(result.tipo, 'moto');
      });
    });

    group('toJson', () {
      test('deve retornar um Map JSON válido', () {
        // Arrange
        const modelo = ModeloFixture.modeloModel;

        // Act
        final result = modelo.toJson();

        // Assert
        final expectedMap = {
          'id': 100,
          'marca_id': 1,
          'nome': 'PALIO 1.0',
          'tipo': 'carro',
        };
        expect(result, equals(expectedMap));
      });

      test('deve usar snake_case para marca_id', () {
        // Arrange
        const modelo = ModeloFixture.modeloModel;

        // Act
        final result = modelo.toJson();

        // Assert
        expect(result.containsKey('marca_id'), true);
        expect(result.containsKey('marcaId'), false);
      });
    });

    group('fromEntity', () {
      test('deve converter ModeloEntity para ModeloModel', () {
        // Arrange
        const entity = ModeloFixture.modeloEntity;

        // Act
        final result = ModeloModel.fromEntity(entity);

        // Assert
        expect(result, isA<ModeloModel>());
        expect(result.id, entity.id);
        expect(result.marcaId, entity.marcaId);
        expect(result.nome, entity.nome);
        expect(result.tipo, entity.tipo);
      });

      test('deve preservar todos os campos na conversão', () {
        // Arrange
        const entity = ModeloEntity(
          id: 999,
          marcaId: 88,
          nome: 'TESTE',
          tipo: 'carro',
        );

        // Act
        final result = ModeloModel.fromEntity(entity);

        // Assert
        expect(result.id, 999);
        expect(result.marcaId, 88);
        expect(result.nome, 'TESTE');
        expect(result.tipo, 'carro');
      });
    });

    group('JSON round-trip', () {
      test('deve manter dados após fromJson e toJson', () {
        // Arrange
        final Map<String, dynamic> originalJson = ModeloFixture.modeloJson;

        // Act
        final model = ModeloModel.fromJson(originalJson);
        final resultJson = model.toJson();

        // Assert
        expect(resultJson, equals(originalJson));
      });
    });
  });
}
