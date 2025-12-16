import 'package:equatable/equatable.dart';

/// Entidade que representa uma marca de veículo
class MarcaEntity extends Equatable {
  final int id;
  final String nome;
  final String tipo;

  const MarcaEntity({required this.id, required this.nome, required this.tipo});

  @override
  List<Object?> get props => [id, nome, tipo];
}
