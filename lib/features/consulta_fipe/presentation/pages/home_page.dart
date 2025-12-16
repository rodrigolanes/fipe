import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../widgets/veiculo_type_card.dart';

/// Página inicial com seleção de tipo de veículo
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FIPE Consulta'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            Text(
              'Selecione o tipo de veículo',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Escolha o tipo de veículo que deseja consultar',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
                children: [
                  VeiculoTypeCard(
                    tipo: TipoVeiculo.carro,
                    icon: Icons.directions_car,
                    label: 'Carros',
                    onTap: () => _navigateToMarcas(context, TipoVeiculo.carro),
                  ),
                  VeiculoTypeCard(
                    tipo: TipoVeiculo.moto,
                    icon: Icons.two_wheeler,
                    label: 'Motos',
                    onTap: () => _navigateToMarcas(context, TipoVeiculo.moto),
                  ),
                  VeiculoTypeCard(
                    tipo: TipoVeiculo.caminhao,
                    icon: Icons.local_shipping,
                    label: 'Caminhões',
                    onTap: () =>
                        _navigateToMarcas(context, TipoVeiculo.caminhao),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMarcas(BuildContext context, TipoVeiculo tipo) {
    Navigator.of(context).pushNamed('/marcas', arguments: tipo);
  }
}
