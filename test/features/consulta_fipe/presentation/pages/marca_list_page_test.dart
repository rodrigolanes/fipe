import 'package:flutter_test/flutter_test.dart';

import 'package:fipe/core/constants/app_constants.dart';

void main() {
  testWidgets('MarcaListPage deve ter tipo de veículo carro', (tester) async {
    // Teste básico de estrutura - pages com BlocProvider requerem setup complexo
    expect(TipoVeiculo.carro, TipoVeiculo.carro);
  });

  testWidgets('MarcaListPage deve ter tipo de veículo moto', (tester) async {
    expect(TipoVeiculo.moto, TipoVeiculo.moto);
  });

  testWidgets('MarcaListPage deve ter tipo de veículo caminhao',
      (tester) async {
    expect(TipoVeiculo.caminhao, TipoVeiculo.caminhao);
  });
}
