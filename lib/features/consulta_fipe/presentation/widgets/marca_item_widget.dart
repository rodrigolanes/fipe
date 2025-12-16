import 'package:flutter/material.dart';

import '../../domain/entities/marca_entity.dart';

/// Widget para exibir um item de marca na lista
class MarcaItemWidget extends StatelessWidget {
  final MarcaEntity marca;
  final VoidCallback onTap;

  const MarcaItemWidget({super.key, required this.marca, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).primaryColor.withValues(alpha: 0.1),
          child: Icon(
            Icons.directions_car,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          marca.nome,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
