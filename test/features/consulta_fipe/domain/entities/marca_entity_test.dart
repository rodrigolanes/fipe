import 'package:flutter_test/flutter_test.dart';

import 'package:fipe/features/consulta_fipe/domain/entities/marca_entity.dart';

void main() {
  group('MarcaEntity', () {
    test('deve ser uma instância válida com todos os campos obrigatórios', () {
      // Arrange & Act
      const marca = MarcaEntity(
        id: 1,
        nome: 'FIAT',
        tipo: 'carro',
      );

      // Assert
      expect(marca.id, 1);
      expect(marca.nome, 'FIAT');
      expect(marca.tipo, 'carro');
      expect(marca.totalModelos, null);
      expect(marca.primeiroAno, null);
      expect(marca.ultimoAno, null);
    });

    test('deve ser uma instância válida com campos opcionais', () {
      // Arrange & Act
      const marca = MarcaEntity(
        id: 1,
        nome: 'FIAT',
        tipo: 'carro',
        totalModelos: 150,
        primeiroAno: 1990,
        ultimoAno: 2026,
      );

      // Assert
      expect(marca.id, 1);
      expect(marca.nome, 'FIAT');
      expect(marca.tipo, 'carro');
      expect(marca.totalModelos, 150);
      expect(marca.primeiroAno, 1990);
      expect(marca.ultimoAno, 2026);
    });

    test('deve implementar Equatable corretamente - instâncias iguais', () {
      // Arrange
      const marca1 = MarcaEntity(
        id: 1,
        nome: 'FIAT',
        tipo: 'carro',
        totalModelos: 150,
      );
      const marca2 = MarcaEntity(
        id: 1,
        nome: 'FIAT',
        tipo: 'carro',
        totalModelos: 150,
      );

      // Assert
      expect(marca1, equals(marca2));
      expect(marca1.hashCode, equals(marca2.hashCode));
    });

    test('deve implementar Equatable corretamente - instâncias diferentes', () {
      // Arrange
      const marca1 = MarcaEntity(
        id: 1,
        nome: 'FIAT',
        tipo: 'carro',
      );
      const marca2 = MarcaEntity(
        id: 2,
        nome: 'VOLKSWAGEN',
        tipo: 'carro',
      );

      // Assert
      expect(marca1, isNot(equals(marca2)));
    });

    test('deve considerar diferentes quando totalModelos for diferente', () {
      // Arrange
      const marca1 = MarcaEntity(
        id: 1,
        nome: 'FIAT',
        tipo: 'carro',
        totalModelos: 150,
      );
      const marca2 = MarcaEntity(
        id: 1,
        nome: 'FIAT',
        tipo: 'carro',
        totalModelos: 200,
      );

      // Assert
      expect(marca1, isNot(equals(marca2)));
    });

    test('deve incluir todos os campos nas props', () {
      // Arrange
      const marca = MarcaEntity(
        id: 1,
        nome: 'FIAT',
        tipo: 'carro',
        totalModelos: 150,
        primeiroAno: 1990,
        ultimoAno: 2026,
      );

      // Assert
      expect(marca.props, [1, 'FIAT', 'carro', 150, 1990, 2026]);
    });

    test('deve incluir null nas props quando campos opcionais forem null', () {
      // Arrange
      const marca = MarcaEntity(
        id: 1,
        nome: 'FIAT',
        tipo: 'carro',
      );

      // Assert
      expect(marca.props, [1, 'FIAT', 'carro', null, null, null]);
    });
  });
}
