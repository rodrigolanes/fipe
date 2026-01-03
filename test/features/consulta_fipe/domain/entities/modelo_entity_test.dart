import 'package:flutter_test/flutter_test.dart';

import 'package:fipe/features/consulta_fipe/domain/entities/modelo_entity.dart';

void main() {
  group('ModeloEntity', () {
    test('deve ser uma instância válida com todos os campos', () {
      // Arrange & Act
      const modelo = ModeloEntity(
        id: 100,
        marcaId: 1,
        nome: 'PALIO 1.0',
        tipo: 'carro',
      );

      // Assert
      expect(modelo.id, 100);
      expect(modelo.marcaId, 1);
      expect(modelo.nome, 'PALIO 1.0');
      expect(modelo.tipo, 'carro');
    });

    test('deve implementar Equatable corretamente - instâncias iguais', () {
      // Arrange
      const modelo1 = ModeloEntity(
        id: 100,
        marcaId: 1,
        nome: 'PALIO 1.0',
        tipo: 'carro',
      );
      const modelo2 = ModeloEntity(
        id: 100,
        marcaId: 1,
        nome: 'PALIO 1.0',
        tipo: 'carro',
      );

      // Assert
      expect(modelo1, equals(modelo2));
      expect(modelo1.hashCode, equals(modelo2.hashCode));
    });

    test('deve implementar Equatable corretamente - instâncias diferentes', () {
      // Arrange
      const modelo1 = ModeloEntity(
        id: 100,
        marcaId: 1,
        nome: 'PALIO 1.0',
        tipo: 'carro',
      );
      const modelo2 = ModeloEntity(
        id: 101,
        marcaId: 1,
        nome: 'UNO 1.0',
        tipo: 'carro',
      );

      // Assert
      expect(modelo1, isNot(equals(modelo2)));
    });

    test('deve considerar diferentes quando marcaId for diferente', () {
      // Arrange
      const modelo1 = ModeloEntity(
        id: 100,
        marcaId: 1,
        nome: 'PALIO 1.0',
        tipo: 'carro',
      );
      const modelo2 = ModeloEntity(
        id: 100,
        marcaId: 2,
        nome: 'PALIO 1.0',
        tipo: 'carro',
      );

      // Assert
      expect(modelo1, isNot(equals(modelo2)));
    });

    test('deve incluir todos os campos nas props', () {
      // Arrange
      const modelo = ModeloEntity(
        id: 100,
        marcaId: 1,
        nome: 'PALIO 1.0',
        tipo: 'carro',
      );

      // Assert
      expect(modelo.props, [100, 1, 'PALIO 1.0', 'carro']);
    });

    test('deve funcionar com tipo moto', () {
      // Arrange & Act
      const modelo = ModeloEntity(
        id: 200,
        marcaId: 10,
        nome: 'CG 160 FAN',
        tipo: 'moto',
      );

      // Assert
      expect(modelo.id, 200);
      expect(modelo.marcaId, 10);
      expect(modelo.nome, 'CG 160 FAN');
      expect(modelo.tipo, 'moto');
    });

    test('deve funcionar com tipo caminhão', () {
      // Arrange & Act
      const modelo = ModeloEntity(
        id: 300,
        marcaId: 100,
        nome: 'CONSTELLATION 24.250',
        tipo: 'caminhao',
      );

      // Assert
      expect(modelo.id, 300);
      expect(modelo.tipo, 'caminhao');
    });
  });
}
