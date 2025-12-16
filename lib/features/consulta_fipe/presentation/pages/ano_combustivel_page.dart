import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../injection_container.dart';
import '../bloc/ano_combustivel_bloc.dart';
import '../bloc/ano_combustivel_event.dart';
import '../bloc/ano_combustivel_state.dart';
import '../widgets/ano_combustivel_chip.dart';
import '../widgets/error_widget.dart' as custom;
import '../widgets/loading_widget.dart';

/// Página de seleção de ano e combustível
class AnoCombustivelPage extends StatelessWidget {
  final int marcaId;
  final int modeloId;
  final TipoVeiculo tipo;

  const AnoCombustivelPage({
    super.key,
    required this.marcaId,
    required this.modeloId,
    required this.tipo,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AnoCombustivelBloc>()
        ..add(
          LoadAnosCombustiveisPorModeloEvent(modeloId: modeloId, tipo: tipo),
        ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Ano e Combustível')),
        body: BlocBuilder<AnoCombustivelBloc, AnoCombustivelState>(
          builder: (context, state) {
            if (state is AnoCombustivelLoading) {
              return const LoadingWidget();
            } else if (state is AnoCombustivelLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Selecione o ano e combustível',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${state.anosCombustiveis.length} opções disponíveis',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2.5,
                            ),
                        itemCount: state.anosCombustiveis.length,
                        itemBuilder: (context, index) {
                          final anoCombustivel = state.anosCombustiveis[index];
                          return AnoCombustivelChip(
                            anoCombustivel: anoCombustivel,
                            onTap: () => _navigateToValorDetalhes(
                              context,
                              anoCombustivel.ano,
                              anoCombustivel.combustivel,
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
                  LoadAnosCombustiveisPorModeloEvent(
                    modeloId: modeloId,
                    tipo: tipo,
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _navigateToValorDetalhes(
    BuildContext context,
    String ano,
    String combustivel,
  ) {
    Navigator.of(context).pushNamed(
      '/valor-detalhes',
      arguments: {
        'marcaId': marcaId,
        'modeloId': modeloId,
        'ano': ano,
        'combustivel': combustivel,
        'tipo': tipo,
      },
    );
  }
}
