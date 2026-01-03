import 'package:flutter_test/flutter_test.dart';

import 'package:fipe/features/consulta_fipe/domain/entities/ano_combustivel_entity.dart';

void main() {
  group('AnoCombustivelEntity', () {
    test('deve ser uma instância válida com todos os campos', () {
      // Arrange & Act
      const anoCombustivel = AnoCombustivelEntity(
        ano: '2024',
        combustivel: 'Gasolina',
        codigoFipe: '001234-5',
      );

      // Assert
      expect(anoCombustivel.ano, '2024');
      expect(anoCombustivel.combustivel, 'Gasolina');
      expect(anoCombustivel.codigoFipe, '001234-5');
    });

    test('deve funcionar com ano Zero KM', () {
      // Arrange & Act
      const anoCombustivel = AnoCombustivelEntity(
        ano: '32000',
        combustivel: 'Gasolina',
        codigoFipe: '001234-5',
      );

      // Assert
      expect(anoCombustivel.ano, '32000');
    });

    test('deve implementar Equatable corretamente - instâncias iguais', () {
      // Arrange
      const anoCombustivel1 = AnoCombustivelEntity(
        ano: '2024',
        combustivel: 'Gasolina',
        codigoFipe: '001234-5',
      );
      const anoCombustivel2 = AnoCombustivelEntity(
        ano: '2024',
        combustivel: 'Gasolina',
        codigoFipe: '001234-5',
      );

      // Assert
      expect(anoCombustivel1, equals(anoCombustivel2));
      expect(anoCombustivel1.hashCode, equals(anoCombustivel2.hashCode));
    });

    test('deve implementar Equatable corretamente - instâncias diferentes', () {
      // Arrange
      const anoCombustivel1 = AnoCombustivelEntity(
        ano: '2024',
        combustivel: 'Gasolina',
        codigoFipe: '001234-5',
      );
      const anoCombustivel2 = AnoCombustivelEntity(
        ano: '2023',
        combustivel: 'Gasolina',
        codigoFipe: '001233-4',
      );

      // Assert
      expect(anoCombustivel1, isNot(equals(anoCombustivel2)));
    });

    test('deve considerar diferentes quando combustível for diferente', () {
      // Arrange
      const anoCombustivel1 = AnoCombustivelEntity(
        ano: '2024',
        combustivel: 'Gasolina',
        codigoFipe: '001234-5',
      );
      const anoCombustivel2 = AnoCombustivelEntity(
        ano: '2024',
        combustivel: 'Flex',
        codigoFipe: '001234-5',
      );

      // Assert
      expect(anoCombustivel1, isNot(equals(anoCombustivel2)));
    });

    test('deve incluir todos os campos nas props', () {
      // Arrange
      const anoCombustivel = AnoCombustivelEntity(
        ano: '2024',
        combustivel: 'Gasolina',
        codigoFipe: '001234-5',
      );

      // Assert
      expect(anoCombustivel.props, ['2024', 'Gasolina', '001234-5']);
    });

    test('deve funcionar com diferentes tipos de combustível', () {
      // Gasolina
      const gasolina = AnoCombustivelEntity(
        ano: '2024',
        combustivel: 'Gasolina',
        codigoFipe: '001234-5',
      );
      expect(gasolina.combustivel, 'Gasolina');

      // Flex
      const flex = AnoCombustivelEntity(
        ano: '2024',
        combustivel: 'Flex',
        codigoFipe: '001234-6',
      );
      expect(flex.combustivel, 'Flex');

      // Diesel
      const diesel = AnoCombustivelEntity(
        ano: '2024',
        combustivel: 'Diesel',
        codigoFipe: '001234-7',
      );
      expect(diesel.combustivel, 'Diesel');

      // Álcool
      const alcool = AnoCombustivelEntity(
        ano: '2024',
        combustivel: 'Álcool',
        codigoFipe: '001234-8',
      );
      expect(alcool.combustivel, 'Álcool');
    });
  });
}
