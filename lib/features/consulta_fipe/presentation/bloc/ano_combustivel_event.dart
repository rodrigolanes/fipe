import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_constants.dart';

/// Eventos do AnoCombustivelBloc
abstract class AnoCombustivelEvent extends Equatable {
  const AnoCombustivelEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para carregar anos e combustíveis por modelo
class LoadAnosCombustiveisPorModeloEvent extends AnoCombustivelEvent {
  final int modeloId;
  final TipoVeiculo tipo;

  const LoadAnosCombustiveisPorModeloEvent({
    required this.modeloId,
    required this.tipo,
  });

  @override
  List<Object?> get props => [modeloId, tipo];
}
