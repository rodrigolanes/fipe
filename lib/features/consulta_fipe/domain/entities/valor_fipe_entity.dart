import 'package:equatable/equatable.dart';

/// Entidade que representa o valor FIPE de um veículo
class ValorFipeEntity extends Equatable {
  final String marca;
  final String modelo;
  final int anoModelo;
  final String combustivel;
  final String codigoFipe;
  final String mesReferencia;
  final String valor;
  final DateTime dataConsulta;

  const ValorFipeEntity({
    required this.marca,
    required this.modelo,
    required this.anoModelo,
    required this.combustivel,
    required this.codigoFipe,
    required this.mesReferencia,
    required this.valor,
    required this.dataConsulta,
  });

  @override
  List<Object?> get props => [
        marca,
        modelo,
        anoModelo,
        combustivel,
        codigoFipe,
        mesReferencia,
        valor,
        dataConsulta,
      ];
}
