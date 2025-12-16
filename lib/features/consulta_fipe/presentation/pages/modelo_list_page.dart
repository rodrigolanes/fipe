import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../injection_container.dart';
import '../bloc/modelo_bloc.dart';
import '../bloc/modelo_event.dart';
import '../bloc/modelo_state.dart';
import '../widgets/error_widget.dart' as custom;
import '../widgets/loading_widget.dart';
import '../widgets/modelo_item_widget.dart';
import '../widgets/search_bar_widget.dart';

/// Página de listagem de modelos
class ModeloListPage extends StatelessWidget {
  final int marcaId;
  final TipoVeiculo tipo;

  const ModeloListPage({super.key, required this.marcaId, required this.tipo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ModeloBloc>()
            ..add(LoadModelosPorMarcaEvent(marcaId: marcaId, tipo: tipo)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Modelos')),
        body: Column(
          children: [
            BlocBuilder<ModeloBloc, ModeloState>(
              builder: (context, state) {
                if (state is ModeloLoaded) {
                  return SearchBarWidget(
                    hintText: 'Buscar modelo...',
                    onChanged: (query) {
                      context.read<ModeloBloc>().add(SearchModelosEvent(query));
                    },
                    onClear: () {
                      context.read<ModeloBloc>().add(
                        const ClearSearchModelosEvent(),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Expanded(
              child: BlocBuilder<ModeloBloc, ModeloState>(
                builder: (context, state) {
                  if (state is ModeloLoading) {
                    return const LoadingWidget();
                  } else if (state is ModeloLoaded) {
                    if (state.filteredModelos.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum modelo encontrado',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.filteredModelos.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final modelo = state.filteredModelos[index];
                        return ModeloItemWidget(
                          modelo: modelo,
                          onTap: () =>
                              _navigateToAnosCombustiveis(context, modelo.id),
                        );
                      },
                    );
                  } else if (state is ModeloError) {
                    return custom.ErrorWidget(
                      message: state.message,
                      onRetry: () => context.read<ModeloBloc>().add(
                        LoadModelosPorMarcaEvent(marcaId: marcaId, tipo: tipo),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAnosCombustiveis(BuildContext context, int modeloId) {
    Navigator.of(context).pushNamed(
      '/anos-combustiveis',
      arguments: {'marcaId': marcaId, 'modeloId': modeloId, 'tipo': tipo},
    );
  }
}
