import 'package:equatable/equatable.dart';

/// Entidade que representa um ano e tipo de combustível
class AnoCombustivelEntity extends Equatable {
  final String ano;
  final String combustivel;
  final String codigoFipe;

  const AnoCombustivelEntity({
    required this.ano,
    required this.combustivel,
    required this.codigoFipe,
  });

  @override
  List<Object?> get props => [ano, combustivel, codigoFipe];
}
