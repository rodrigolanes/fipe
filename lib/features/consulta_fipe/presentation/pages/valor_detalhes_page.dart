import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/share_service.dart';
import '../../../../injection_container.dart';
import '../bloc/valor_fipe_bloc.dart';
import '../bloc/valor_fipe_event.dart';
import '../bloc/valor_fipe_state.dart';
import '../widgets/error_widget.dart' as custom;
import '../widgets/loading_widget.dart';
import '../widgets/valor_card_widget.dart';

/// Página de detalhes do valor FIPE
class ValorDetalhesPage extends StatelessWidget {
  final int marcaId;
  final int modeloId;
  final String ano;
  final String combustivel;
  final TipoVeiculo tipo;

  const ValorDetalhesPage({
    super.key,
    required this.marcaId,
    required this.modeloId,
    required this.ano,
    required this.combustivel,
    required this.tipo,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ValorFipeBloc>()
        ..add(
          LoadValorFipeEvent(
            marcaId: marcaId,
            modeloId: modeloId,
            ano: ano,
            combustivel: combustivel,
            tipo: tipo,
          ),
        ),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Valor FIPE'),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _shareValue(context),
              ),
            ],
          ),
          body: SafeArea(
            child: BlocBuilder<ValorFipeBloc, ValorFipeState>(
              builder: (context, state) {
                if (state is ValorFipeLoading) {
                  return const LoadingWidget();
                } else if (state is ValorFipeLoaded) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ValorCardWidget(valorFipe: state.valorFipe),
                        const SizedBox(height: 24),
                        _buildInfoCard(context, state),
                        const SizedBox(height: 16),
                        _buildDisclaimerCard(context),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst),
                          icon: const Icon(Icons.home),
                          label: const Text('Nova Consulta'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is ValorFipeError) {
                  return custom.ErrorWidget(
                    message: state.message,
                    onRetry: () => context.read<ValorFipeBloc>().add(
                          LoadValorFipeEvent(
                            marcaId: marcaId,
                            modeloId: modeloId,
                            ano: ano,
                            combustivel: combustivel,
                            tipo: tipo,
                          ),
                        ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, ValorFipeLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informações Adicionais',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              Icons.calendar_today,
              'Mês de Referência',
              state.valorFipe.mesReferencia,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              context,
              Icons.code,
              'Código FIPE',
              state.valorFipe.codigoFipe,
            ),
            const Divider(height: 24),
            _buildInfoRow(
              context,
              Icons.update,
              'Data da Consulta',
              _formatDate(state.valorFipe.dataConsulta),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDisclaimerCard(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Os valores apresentados são baseados na Tabela FIPE e servem como referência média de mercado.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.blue.shade900),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  void _shareValue(BuildContext context) async {
    final state = context.read<ValorFipeBloc>().state;
    if (state is ValorFipeLoaded) {
      try {
        await ShareService.compartilharValorFipe(state.valorFipe);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Compartilhamento aberto'),
                ],
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Erro ao compartilhar: $e')),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.warning, color: Colors.white),
                SizedBox(width: 12),
                Text('Aguarde o carregamento dos dados'),
              ],
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
