import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

/// Card para seleção de tipo de veículo
class VeiculoTypeCard extends StatelessWidget {
  final TipoVeiculo tipo;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const VeiculoTypeCard({
    super.key,
    required this.tipo,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 64, color: Theme.of(context).primaryColor),
              const SizedBox(height: 16),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
