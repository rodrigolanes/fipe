import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ads/ad_banner_widget.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../../injection_container.dart' as di;
import '../bloc/sync_bloc.dart';
import '../widgets/veiculo_type_card.dart';

/// Página inicial com seleção de tipo de veículo
class HomePage extends StatefulWidget {
  final ThemeManager themeManager;

  const HomePage({super.key, required this.themeManager});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final SyncBloc _syncBloc;

  @override
  void initState() {
    super.initState();
    _syncBloc = di.sl<SyncBloc>();
  }

  @override
  void dispose() {
    // SyncBloc é singleton, não fechamos aqui
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SyncBloc>.value(
      value: _syncBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('FIPE Consulta'),
          centerTitle: true,
          automaticallyImplyLeading: false, // Remove a seta de voltar
          actions: [
            IconButton(
              icon: Icon(widget.themeManager.themeIcon),
              tooltip: widget.themeManager.themeLabel,
              onPressed: () async {
                await widget.themeManager.toggleTheme();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('${widget.themeManager.themeLabel} ativado'),
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
            // Banner de sincronização em andamento
            BlocBuilder<SyncBloc, SyncState>(
              builder: (context, state) {
                if (state is Syncing) {
                  return Container(
                    width: double.infinity,
                    color: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.progressMessage,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
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
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
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
      ),
    );
  }

  void _navigateToMarcas(BuildContext context, TipoVeiculo tipo) {
    Navigator.of(context).pushNamed('/marcas', arguments: tipo);
  }
}
