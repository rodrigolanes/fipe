import 'package:flutter_test/flutter_test.dart';

import 'package:fipe/features/consulta_fipe/domain/entities/valor_fipe_entity.dart';

void main() {
  group('ValorFipeEntity', () {
    final dataConsulta = DateTime(2026, 1, 2, 10, 30);

    test('deve ser uma instância válida com todos os campos', () {
      // Arrange & Act
      final valorFipe = ValorFipeEntity(
        marca: 'FIAT',
        modelo: 'PALIO 1.0',
        anoModelo: 2024,
        combustivel: 'Gasolina',
        codigoFipe: '001234-5',
        mesReferencia: '202601',
        valor: 'R\$ 45.000,00',
        dataConsulta: dataConsulta,
      );

      // Assert
      expect(valorFipe.marca, 'FIAT');
      expect(valorFipe.modelo, 'PALIO 1.0');
      expect(valorFipe.anoModelo, 2024);
      expect(valorFipe.combustivel, 'Gasolina');
      expect(valorFipe.codigoFipe, '001234-5');
      expect(valorFipe.mesReferencia, '202601');
      expect(valorFipe.valor, 'R\$ 45.000,00');
      expect(valorFipe.dataConsulta, dataConsulta);
    });

    test('deve funcionar com veículo Zero KM (ano 32000)', () {
      // Arrange & Act
      final valorFipe = ValorFipeEntity(
        marca: 'FIAT',
        modelo: 'ARGO 1.0',
        anoModelo: 32000,
        combustivel: 'Flex',
        codigoFipe: '001235-6',
        mesReferencia: '202601',
        valor: 'R\$ 68.500,00',
        dataConsulta: dataConsulta,
      );

      // Assert
      expect(valorFipe.anoModelo, 32000);
    });

    test('deve implementar Equatable corretamente - instâncias iguais', () {
      // Arrange
      final valorFipe1 = ValorFipeEntity(
        marca: 'FIAT',
        modelo: 'PALIO 1.0',
        anoModelo: 2024,
        combustivel: 'Gasolina',
        codigoFipe: '001234-5',
        mesReferencia: '202601',
        valor: 'R\$ 45.000,00',
        dataConsulta: dataConsulta,
      );
      final valorFipe2 = ValorFipeEntity(
        marca: 'FIAT',
        modelo: 'PALIO 1.0',
        anoModelo: 2024,
        combustivel: 'Gasolina',
        codigoFipe: '001234-5',
        mesReferencia: '202601',
        valor: 'R\$ 45.000,00',
        dataConsulta: dataConsulta,
      );

      // Assert
      expect(valorFipe1, equals(valorFipe2));
      expect(valorFipe1.hashCode, equals(valorFipe2.hashCode));
    });

    test('deve implementar Equatable corretamente - instâncias diferentes', () {
      // Arrange
      final valorFipe1 = ValorFipeEntity(
        marca: 'FIAT',
        modelo: 'PALIO 1.0',
        anoModelo: 2024,
        combustivel: 'Gasolina',
        codigoFipe: '001234-5',
        mesReferencia: '202601',
        valor: 'R\$ 45.000,00',
        dataConsulta: dataConsulta,
      );
      final valorFipe2 = ValorFipeEntity(
        marca: 'FIAT',
        modelo: 'UNO 1.0',
        anoModelo: 2024,
        combustivel: 'Gasolina',
        codigoFipe: '001235-6',
        mesReferencia: '202601',
        valor: 'R\$ 42.000,00',
        dataConsulta: dataConsulta,
      );

      // Assert
      expect(valorFipe1, isNot(equals(valorFipe2)));
    });

    test('deve considerar diferentes quando valor for diferente', () {
      // Arrange
      final valorFipe1 = ValorFipeEntity(
        marca: 'FIAT',
        modelo: 'PALIO 1.0',
        anoModelo: 2024,
        combustivel: 'Gasolina',
        codigoFipe: '001234-5',
        mesReferencia: '202601',
        valor: 'R\$ 45.000,00',
        dataConsulta: dataConsulta,
      );
      final valorFipe2 = ValorFipeEntity(
        marca: 'FIAT',
        modelo: 'PALIO 1.0',
        anoModelo: 2024,
        combustivel: 'Gasolina',
        codigoFipe: '001234-5',
        mesReferencia: '202601',
        valor: 'R\$ 46.000,00',
        dataConsulta: dataConsulta,
      );

      // Assert
      expect(valorFipe1, isNot(equals(valorFipe2)));
    });

    test('deve incluir todos os campos nas props', () {
      // Arrange
      final valorFipe = ValorFipeEntity(
        marca: 'FIAT',
        modelo: 'PALIO 1.0',
        anoModelo: 2024,
        combustivel: 'Gasolina',
        codigoFipe: '001234-5',
        mesReferencia: '202601',
        valor: 'R\$ 45.000,00',
        dataConsulta: dataConsulta,
      );

      // Assert
      expect(valorFipe.props, [
        'FIAT',
        'PALIO 1.0',
        2024,
        'Gasolina',
        '001234-5',
        '202601',
        'R\$ 45.000,00',
        dataConsulta,
      ]);
    });

    test('deve aceitar valores altos', () {
      // Arrange & Act
      final valorFipe = ValorFipeEntity(
        marca: 'BMW',
        modelo: 'X5 3.0',
        anoModelo: 2024,
        combustivel: 'Diesel',
        codigoFipe: '999999-9',
        mesReferencia: '202601',
        valor: 'R\$ 650.000,00',
        dataConsulta: dataConsulta,
      );

      // Assert
      expect(valorFipe.valor, 'R\$ 650.000,00');
    });

    test('deve aceitar diferentes formatos de código FIPE', () {
      // Arrange & Act
      final valorFipe = ValorFipeEntity(
        marca: 'FIAT',
        modelo: 'PALIO 1.0',
        anoModelo: 2024,
        combustivel: 'Gasolina',
        codigoFipe: '123456-7',
        mesReferencia: '202601',
        valor: 'R\$ 45.000,00',
        dataConsulta: dataConsulta,
      );

      // Assert
      expect(valorFipe.codigoFipe, '123456-7');
    });
  });
}
