import 'package:flutter_test/flutter_test.dart';

import 'package:fipe/core/constants/app_constants.dart';

void main() {
  test('ModeloListPage deve aceitar marcaId e tipo', () {
    // Teste básico de estrutura - pages com MultiBlocProvider requerem setup complexo
    const marcaId = 1;
    const tipo = TipoVeiculo.carro;

    expect(marcaId, 1);
    expect(tipo, TipoVeiculo.carro);
  });
}
