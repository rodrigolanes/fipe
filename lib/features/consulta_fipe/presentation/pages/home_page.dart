import 'package:flutter/material.dart';

import '../../../../core/ads/ad_banner_widget.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_manager.dart';
import '../widgets/veiculo_type_card.dart';

/// Página inicial com seleção de tipo de veículo
class HomePage extends StatelessWidget {
  final ThemeManager themeManager;

  const HomePage({super.key, required this.themeManager});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FIPE Consulta'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(themeManager.themeIcon),
            tooltip: themeManager.themeLabel,
            onPressed: () async {
              await themeManager.toggleTheme();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${themeManager.themeLabel} ativado'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      'Selecione o tipo de veículo',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
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
                        childAspectRatio: 0.85,
                        children: [
                          VeiculoTypeCard(
                            tipo: TipoVeiculo.carro,
                            icon: Icons.directions_car,
                            label: 'Carros',
                            onTap: () =>
                                _navigateToMarcas(context, TipoVeiculo.carro),
                          ),
                          VeiculoTypeCard(
                            tipo: TipoVeiculo.moto,
                            icon: Icons.two_wheeler,
                            label: 'Motos',
                            onTap: () =>
                                _navigateToMarcas(context, TipoVeiculo.moto),
                          ),
                          VeiculoTypeCard(
                            tipo: TipoVeiculo.caminhao,
                            icon: Icons.local_shipping,
                            label: 'Caminhões',
                            onTap: () => _navigateToMarcas(
                                context, TipoVeiculo.caminhao),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const AdBannerWidget(),
        ],
      ),
    );
  }

  void _navigateToMarcas(BuildContext context, TipoVeiculo tipo) {
    Navigator.of(context).pushNamed('/marcas', arguments: tipo);
  }
}
