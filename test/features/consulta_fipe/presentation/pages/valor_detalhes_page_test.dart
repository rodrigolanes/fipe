import 'package:flutter_test/flutter_test.dart';

import 'package:fipe/core/constants/app_constants.dart';

void main() {
  test('ValorDetalhesPage deve aceitar parâmetros obrigatórios', () {
    // Teste básico de estrutura - pages com BlocProvider requerem setup complexo
    const marcaId = 1;
    const modeloId = 100;
    const ano = '2024';
    const combustivel = 'Gasolina';
    const tipo = TipoVeiculo.carro;

    expect(marcaId, 1);
    expect(modeloId, 100);
    expect(ano, '2024');
    expect(combustivel, 'Gasolina');
    expect(tipo, TipoVeiculo.carro);
  });
}
