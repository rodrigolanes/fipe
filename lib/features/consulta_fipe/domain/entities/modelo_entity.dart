import 'package:equatable/equatable.dart';

/// Entidade que representa um modelo de veículo
class ModeloEntity extends Equatable {
  final int id;
  final int marcaId;
  final String nome;
  final String tipo;

  const ModeloEntity({
    required this.id,
    required this.marcaId,
    required this.nome,
    required this.tipo,
  });

  @override
  List<Object?> get props => [id, marcaId, nome, tipo];
}
