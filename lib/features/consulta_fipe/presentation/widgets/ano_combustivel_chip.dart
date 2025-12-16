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
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                anoCombustivel.ano,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                anoCombustivel.combustivel,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
