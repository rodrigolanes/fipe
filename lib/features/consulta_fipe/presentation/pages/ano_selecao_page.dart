import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../injection_container.dart';
import '../bloc/ano_combustivel_bloc.dart';
import '../bloc/ano_combustivel_event.dart';
import '../bloc/ano_combustivel_state.dart';
import '../widgets/error_widget.dart' as custom;
import '../widgets/loading_widget.dart';

/// Página para seleção de ano após escolher a marca
class AnoSelecaoPage extends StatelessWidget {
  final int marcaId;
  final TipoVeiculo tipo;

  const AnoSelecaoPage({super.key, required this.marcaId, required this.tipo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<AnoCombustivelBloc>()
            ..add(LoadAnosPorMarcaEvent(marcaId: marcaId, tipo: tipo)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Selecione o Ano')),
        body: SafeArea(
          child: BlocBuilder<AnoCombustivelBloc, AnoCombustivelState>(
            builder: (context, state) {
              if (state is AnoCombustivelLoading) {
                return const LoadingWidget();
              } else if (state is AnoCombustivelLoaded) {
                // Extrair anos únicos e ordenar
                final anos =
                    state.anosCombustiveis.map((ac) => ac.ano).toSet().toList()
                      ..sort((a, b) {
                        // Zero Km (32000) sempre no início
                        if (a == '32000') return -1;
                        if (b == '32000') return 1;
                        // Ordenar do mais recente para o mais antigo
                        return int.parse(b).compareTo(int.parse(a));
                      });

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Selecione o ano do veículo',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${anos.length} ano${anos.length == 1 ? '' : 's'} disponível${anos.length == 1 ? '' : 'eis'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: anos.length,
                          itemBuilder: (context, index) {
                            final ano = anos[index];
                            final isZeroKm = ano == '32000';
                            final anoExibicao = isZeroKm ? 'Zero Km' : ano;

                            return Card(
                              elevation: 1,
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                onTap: () => _navigateToModelos(context, ano),
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isZeroKm
                                        ? Colors.amber.withValues(alpha: 0.1)
                                        : Theme.of(
                                            context,
                                          ).primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    isZeroKm
                                        ? Icons.new_releases
                                        : Icons.calendar_today,
                                    color: isZeroKm
                                        ? Colors.amber.shade700
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                                title: Text(
                                  anoExibicao,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: isZeroKm
                                    ? const Text('Veículos novos')
                                    : null,
                                trailing: const Icon(Icons.chevron_right),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is AnoCombustivelError) {
                return custom.ErrorWidget(
                  message: state.message,
                  onRetry: () => context.read<AnoCombustivelBloc>().add(
                    LoadAnosPorMarcaEvent(marcaId: marcaId, tipo: tipo),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  void _navigateToModelos(BuildContext context, String ano) {
    Navigator.of(context).pushNamed(
      '/modelos',
      arguments: {'marcaId': marcaId, 'tipo': tipo, 'ano': ano},
    );
  }
}
