import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../injection_container.dart';
import '../../domain/usecases/get_anos_combustiveis_por_modelo_usecase.dart';
import '../bloc/ano_combustivel_bloc.dart';
import '../bloc/ano_combustivel_event.dart';
import '../bloc/ano_combustivel_state.dart';
import '../bloc/modelo_bloc.dart';
import '../bloc/modelo_event.dart';
import '../bloc/modelo_state.dart';
import '../widgets/error_widget.dart' as custom;
import '../widgets/loading_widget.dart';
import '../widgets/modelo_item_widget.dart';
import '../widgets/search_bar_widget.dart';

/// Página de listagem de modelos com filtro opcional de ano
class ModeloListPage extends StatefulWidget {
  final int marcaId;
  final TipoVeiculo tipo;

  const ModeloListPage({super.key, required this.marcaId, required this.tipo});

  @override
  State<ModeloListPage> createState() => _ModeloListPageState();
}

class _ModeloListPageState extends State<ModeloListPage> {
  String? anoSelecionado;
  List<String> anosDisponiveis = [];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ModeloBloc>()
            ..add(
              LoadModelosPorMarcaEvent(
                marcaId: widget.marcaId,
                tipo: widget.tipo,
              ),
            ),
        ),
        BlocProvider(
          create: (_) => sl<AnoCombustivelBloc>()
            ..add(
              LoadAnosPorMarcaEvent(marcaId: widget.marcaId, tipo: widget.tipo),
            ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Modelos')),
        body: SafeArea(
          child: Column(
            children: [
              // Filtro de ano
              BlocBuilder<AnoCombustivelBloc, AnoCombustivelState>(
                builder: (context, state) {
                  if (state is AnoCombustivelLoaded) {
                    // Extrair anos únicos
                    final anos =
                        state.anosCombustiveis
                            .map((ac) => ac.ano)
                            .toSet()
                            .toList()
                          ..sort((a, b) {
                            if (a == '32000') return -1;
                            if (b == '32000') return 1;
                            return int.parse(b).compareTo(int.parse(a));
                          });

                    if (anosDisponiveis.isEmpty && anos.isNotEmpty) {
                      anosDisponiveis = anos;
                    }

                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.filter_alt,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Filtrar por ano',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              // Chip "Todos"
                              FilterChip(
                                label: Text(
                                  'Todos',
                                  style: TextStyle(
                                    color: anoSelecionado == null
                                        ? Colors.white
                                        : null,
                                  ),
                                ),
                                selected: anoSelecionado == null,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() => anoSelecionado = null);
                                    context.read<ModeloBloc>().add(
                                      LoadModelosPorMarcaEvent(
                                        marcaId: widget.marcaId,
                                        tipo: widget.tipo,
                                      ),
                                    );
                                  }
                                },
                              ),
                              // Chips de anos (reorganizar para mostrar ano selecionado)
                              ...() {
                                final List<String> anosVisiveis;
                                if (anoSelecionado != null &&
                                    !anos.take(10).contains(anoSelecionado)) {
                                  // Se o ano selecionado não está nos primeiros 10, colocá-lo no início
                                  anosVisiveis = [
                                    anoSelecionado!,
                                    ...anos
                                        .where((a) => a != anoSelecionado)
                                        .take(9),
                                  ];
                                } else {
                                  anosVisiveis = anos.take(10).toList();
                                }
                                return anosVisiveis;
                              }().map((ano) {
                                final isZeroKm = ano == '32000';
                                final label = isZeroKm ? 'Zero Km' : ano;
                                return FilterChip(
                                  label: Text(
                                    label,
                                    style: TextStyle(
                                      color: anoSelecionado == ano
                                          ? Colors.white
                                          : null,
                                    ),
                                  ),
                                  selected: anoSelecionado == ano,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() => anoSelecionado = ano);
                                      context.read<ModeloBloc>().add(
                                        LoadModelosPorMarcaEvent(
                                          marcaId: widget.marcaId,
                                          tipo: widget.tipo,
                                          ano: ano,
                                        ),
                                      );
                                    }
                                  },
                                );
                              }),
                              if (anos.length > 10)
                                ActionChip(
                                  label: const Text('Mais anos...'),
                                  onPressed: () => _showAllYears(context, anos),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const Divider(height: 1),
              // Barra de busca
              BlocBuilder<ModeloBloc, ModeloState>(
                builder: (context, state) {
                  if (state is ModeloLoaded) {
                    return SearchBarWidget(
                      hintText: 'Buscar modelo...',
                      onChanged: (query) {
                        context.read<ModeloBloc>().add(
                          SearchModelosEvent(query),
                        );
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
              // Lista de modelos
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
                              const Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum modelo encontrado',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              if (anoSelecionado != null) ...[
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () {
                                    setState(() => anoSelecionado = null);
                                    context.read<ModeloBloc>().add(
                                      LoadModelosPorMarcaEvent(
                                        marcaId: widget.marcaId,
                                        tipo: widget.tipo,
                                      ),
                                    );
                                  },
                                  child: const Text('Limpar filtro'),
                                ),
                              ],
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
                          LoadModelosPorMarcaEvent(
                            marcaId: widget.marcaId,
                            tipo: widget.tipo,
                          ),
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
      ),
    );
  }

  void _showAllYears(BuildContext context, List<String> anos) {
    showModalBottomSheet(
      context: context,
      builder: (modalContext) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selecione um ano',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: anos.length,
                itemBuilder: (context, index) {
                  final ano = anos[index];
                  final isZeroKm = ano == '32000';
                  final label = isZeroKm ? 'Zero Km' : ano;
                  return ListTile(
                    leading: Icon(
                      isZeroKm ? Icons.new_releases : Icons.calendar_today,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(label),
                    trailing: anoSelecionado == ano
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      Navigator.pop(modalContext);
                      setState(() => anoSelecionado = ano);
                      this.context.read<ModeloBloc>().add(
                        LoadModelosPorMarcaEvent(
                          marcaId: widget.marcaId,
                          tipo: widget.tipo,
                          ano: ano,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAnosCombustiveis(BuildContext context, int modeloId) async {
    // Se já existe um ano selecionado, buscar o combustível e ir direto para valor
    if (anoSelecionado != null) {
      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(child: CircularProgressIndicator()),
      );

      // Buscar anos/combustíveis
      final useCase = sl<GetAnosCombustiveisPorModeloUseCase>();
      final result = await useCase(
        GetAnosCombustiveisPorModeloParams(
          modeloId: modeloId,
          tipo: widget.tipo,
        ),
      );

      if (!context.mounted) return;

      // Fechar loading
      Navigator.of(context).pop();

      result.fold(
        (failure) {
          // Em caso de erro, navegar para tela de seleção normalmente
          Navigator.pushNamed(
            context,
            '/anos-combustiveis',
            arguments: {
              'modeloId': modeloId,
              'marcaId': widget.marcaId,
              'tipo': widget.tipo,
            },
          );
        },
        (anosCombustiveis) {
          // Filtrar apenas os combustíveis do ano selecionado
          final combustiveisDoAno = anosCombustiveis
              .where((ac) => ac.ano == anoSelecionado)
              .toList();

          if (combustiveisDoAno.isEmpty) {
            // Se não encontrou nenhum, navegar para tela normal
            Navigator.pushNamed(
              context,
              '/anos-combustiveis',
              arguments: {
                'modeloId': modeloId,
                'marcaId': widget.marcaId,
                'tipo': widget.tipo,
              },
            );
          } else if (combustiveisDoAno.length == 1) {
            // Se tem apenas 1 combustível, navegar direto
            final anoCombustivel = combustiveisDoAno.first;
            Navigator.of(context).pushNamed(
              '/valor-detalhes',
              arguments: {
                'marcaId': widget.marcaId,
                'modeloId': modeloId,
                'ano': anoCombustivel.ano,
                'combustivel': anoCombustivel.combustivel,
                'tipo': widget.tipo,
              },
            );
          } else {
            // Se tem mais de 1 combustível, mostrar modal para escolher
            _showCombustivelSelection(context, modeloId, combustiveisDoAno);
          }
        },
      );
      return;
    }

    // Se não há ano selecionado, navegar para seleção de ano/combustível
    Navigator.pushNamed(
      context,
      '/anos-combustiveis',
      arguments: {
        'modeloId': modeloId,
        'marcaId': widget.marcaId,
        'tipo': widget.tipo,
      },
    );
  }

  void _showCombustivelSelection(
    BuildContext context,
    int modeloId,
    List<dynamic> combustiveis,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (modalContext) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selecione o combustível',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Ano: $anoSelecionado',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 16),
            ...combustiveis.map((anoCombustivel) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    Icons.local_gas_station,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(anoCombustivel.combustivel),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pop(modalContext);
                    Navigator.of(context).pushNamed(
                      '/valor-detalhes',
                      arguments: {
                        'marcaId': widget.marcaId,
                        'modeloId': modeloId,
                        'ano': anoCombustivel.ano,
                        'combustivel': anoCombustivel.combustivel,
                        'tipo': widget.tipo,
                      },
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
