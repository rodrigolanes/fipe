import 'package:flutter/material.dart';

import '../../domain/entities/marca_entity.dart';

/// Widget para exibir um item de marca na lista
class MarcaItemWidget extends StatelessWidget {
  final MarcaEntity marca;
  final VoidCallback onTap;

  const MarcaItemWidget({super.key, required this.marca, required this.onTap});

  String _getAnosDisponibilidade() {
    if (marca.primeiroAno == null || marca.ultimoAno == null) {
      return 'Sem informação de anos';
    }

    final ano = DateTime.now().year;
    final ativa =
        marca.ultimoAno! >=
        ano - 1; // Considera ativa se teve modelo no ano passado ou atual

    if (marca.primeiroAno == marca.ultimoAno) {
      return 'Apenas ${marca.primeiroAno}${ativa ? ' • Ativa' : ''}';
    }

    return '${marca.primeiroAno} - ${marca.ultimoAno}${ativa ? ' • Ativa' : ' • Inativa'}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ano = DateTime.now().year;
    final ativa = (marca.ultimoAno ?? 0) >= ano - 1;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Ícone com status
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: ativa
                      ? theme.primaryColor.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.directions_car,
                  color: ativa ? theme.primaryColor : Colors.grey,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Informações da marca
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      marca.nome,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getAnosDisponibilidade(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                    if (marca.totalModelos != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.car_rental,
                            size: 14,
                            color: theme.primaryColor.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${marca.totalModelos} modelo${marca.totalModelos == 1 ? '' : 's'}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.primaryColor.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Indicador de navegação
              Icon(
                Icons.chevron_right,
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
