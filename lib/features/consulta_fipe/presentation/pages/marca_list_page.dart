import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../injection_container.dart';
import '../bloc/marca_bloc.dart';
import '../bloc/marca_event.dart';
import '../bloc/marca_state.dart';
import '../widgets/error_widget.dart' as custom;
import '../widgets/loading_widget.dart';
import '../widgets/marca_item_widget.dart';
import '../widgets/search_bar_widget.dart';

/// Página de listagem de marcas
class MarcaListPage extends StatelessWidget {
  final TipoVeiculo tipo;

  const MarcaListPage({super.key, required this.tipo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MarcaBloc>()..add(LoadMarcasPorTipoEvent(tipo)),
      child: Scaffold(
        appBar: AppBar(title: Text('${_getTipoLabel()} - Marcas')),
        body: Column(
          children: [
            BlocBuilder<MarcaBloc, MarcaState>(
              builder: (context, state) {
                if (state is MarcaLoaded) {
                  return SearchBarWidget(
                    hintText: 'Buscar marca...',
                    onChanged: (query) {
                      context.read<MarcaBloc>().add(SearchMarcasEvent(query));
                    },
                    onClear: () {
                      context.read<MarcaBloc>().add(
                        const ClearSearchMarcasEvent(),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Expanded(
              child: BlocBuilder<MarcaBloc, MarcaState>(
                builder: (context, state) {
                  if (state is MarcaLoading) {
                    return const LoadingWidget();
                  } else if (state is MarcaLoaded) {
                    if (state.filteredMarcas.isEmpty) {
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
                              'Nenhuma marca encontrada',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.filteredMarcas.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final marca = state.filteredMarcas[index];
                        return MarcaItemWidget(
                          marca: marca,
                          onTap: () => _navigateToModelos(context, marca.id),
                        );
                      },
                    );
                  } else if (state is MarcaError) {
                    return custom.ErrorWidget(
                      message: state.message,
                      onRetry: () => context.read<MarcaBloc>().add(
                        LoadMarcasPorTipoEvent(tipo),
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

  String _getTipoLabel() {
    switch (tipo) {
      case TipoVeiculo.carro:
        return 'Carros';
      case TipoVeiculo.moto:
        return 'Motos';
      case TipoVeiculo.caminhao:
        return 'Caminhões';
    }
  }

  void _navigateToModelos(BuildContext context, int marcaId) {
    Navigator.of(
      context,
    ).pushNamed('/modelos', arguments: {'marcaId': marcaId, 'tipo': tipo});
  }
}
