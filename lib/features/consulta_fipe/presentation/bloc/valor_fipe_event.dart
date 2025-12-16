import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_constants.dart';

/// Eventos do ValorFipeBloc
abstract class ValorFipeEvent extends Equatable {
  const ValorFipeEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para carregar valor FIPE
class LoadValorFipeEvent extends ValorFipeEvent {
  final int marcaId;
  final int modeloId;
  final String ano;
  final String combustivel;
  final TipoVeiculo tipo;

  const LoadValorFipeEvent({
    required this.marcaId,
    required this.modeloId,
    required this.ano,
    required this.combustivel,
    required this.tipo,
  });

  @override
  List<Object?> get props => [marcaId, modeloId, ano, combustivel, tipo];
}
