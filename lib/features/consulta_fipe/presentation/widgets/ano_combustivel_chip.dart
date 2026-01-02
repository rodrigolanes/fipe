import 'package:flutter/material.dart';

import '../../domain/entities/ano_combustivel_entity.dart';

/// Widget chip para exibir ano e combustível
class AnoCombustivelChip extends StatelessWidget {
  final AnoCombustivelEntity anoCombustivel;
  final VoidCallback onTap;

  const AnoCombustivelChip({
    super.key,
    required this.anoCombustivel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                anoCombustivel.ano == '32000' ? 'Zero Km' : anoCombustivel.ano,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                    ),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  anoCombustivel.combustivel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
