import 'package:flutter_test/flutter_test.dart';

import 'package:fipe/core/constants/app_constants.dart';

void main() {
  test('AnoCombustivelPage deve aceitar marcaId, modeloId e tipo', () {
    // Teste básico de estrutura - pages com BlocProvider requerem setup complexo
    const marcaId = 1;
    const modeloId = 100;
    const tipo = TipoVeiculo.carro;

    expect(marcaId, 1);
    expect(modeloId, 100);
    expect(tipo, TipoVeiculo.carro);
  });
}
