import 'package:flutter/material.dart';
import '../../../../core/utils/time_ago_formatter.dart';

/// Widget que exibe indicador de frescor dos dados.
///
/// Mostra se os dados vieram do cache ou da internet, e há quanto tempo
/// foram atualizados.
class DataFreshnessIndicator extends StatelessWidget {
  /// Timestamp de quando os dados foram obtidos/atualizados
  final DateTime timestamp;

  /// Se true, mostra ícone de cache; se false, mostra ícone de nuvem (online)
  final bool isFromCache;

  const DataFreshnessIndicator({
    super.key,
    required this.timestamp,
    this.isFromCache = false,
  });

  @override
  Widget build(BuildContext context) {
    final tempoDecorrido = timestamp.tempoDecorrido();
    final icon = isFromCache ? Icons.storage : Icons.cloud_done;
    final label = isFromCache ? 'Cache' : 'Online';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isFromCache ? Colors.orange.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isFromCache ? Colors.orange.shade200 : Colors.green.shade200,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isFromCache ? Colors.orange.shade700 : Colors.green.shade700,
          ),
          const SizedBox(width: 6),
          Text(
            '$label • $tempoDecorrido',
            style: TextStyle(
              fontSize: 12,
              color:
                  isFromCache ? Colors.orange.shade900 : Colors.green.shade900,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
