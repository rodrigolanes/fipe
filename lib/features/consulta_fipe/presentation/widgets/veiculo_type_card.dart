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

  String _getDescription(TipoVeiculo tipo) {
    switch (tipo) {
      case TipoVeiculo.carro:
        return 'Consulte preços de automóveis';
      case TipoVeiculo.moto:
        return 'Consulte preços de motocicletas';
      case TipoVeiculo.caminhao:
        return 'Consulte preços de veículos pesados';
    }
  }

  Color _getGradientStart(BuildContext context, TipoVeiculo tipo) {
    final primary = Theme.of(context).primaryColor;
    switch (tipo) {
      case TipoVeiculo.carro:
        return primary;
      case TipoVeiculo.moto:
        return Colors.orange;
      case TipoVeiculo.caminhao:
        return Colors.green;
    }
  }

  Color _getGradientEnd(BuildContext context, TipoVeiculo tipo) {
    final primary = Theme.of(context).primaryColor;
    switch (tipo) {
      case TipoVeiculo.carro:
        return primary.withValues(alpha: 0.7);
      case TipoVeiculo.moto:
        return Colors.deepOrange;
      case TipoVeiculo.caminhao:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getGradientStart(context, tipo),
                _getGradientEnd(context, tipo),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 56, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: Text(
                    _getDescription(tipo),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
