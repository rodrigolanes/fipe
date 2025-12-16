import 'package:equatable/equatable.dart';

/// Entidade que representa uma marca de veículo
class MarcaEntity extends Equatable {
  final int id;
  final String nome;
  final String tipo;
  final int? totalModelos;
  final int? primeiroAno;
  final int? ultimoAno;

  const MarcaEntity({
    required this.id,
    required this.nome,
    required this.tipo,
    this.totalModelos,
    this.primeiroAno,
    this.ultimoAno,
  });

  @override
  List<Object?> get props => [
    id,
    nome,
    tipo,
    totalModelos,
    primeiroAno,
    ultimoAno,
  ];
}
