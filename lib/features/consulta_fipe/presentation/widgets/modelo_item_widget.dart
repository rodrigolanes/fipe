import 'package:flutter/material.dart';

import '../../domain/entities/modelo_entity.dart';

/// Widget para exibir um item de modelo na lista
class ModeloItemWidget extends StatelessWidget {
  final ModeloEntity modelo;
  final VoidCallback onTap;

  const ModeloItemWidget({
    super.key,
    required this.modelo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).primaryColor.withValues(alpha: 0.1),
          child: Icon(Icons.drive_eta, color: Theme.of(context).primaryColor),
        ),
        title: Text(
          modelo.nome,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
