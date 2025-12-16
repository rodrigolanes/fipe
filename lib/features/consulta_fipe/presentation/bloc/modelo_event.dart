import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_constants.dart';

/// Eventos do ModeloBloc
abstract class ModeloEvent extends Equatable {
  const ModeloEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para carregar modelos por marca
class LoadModelosPorMarcaEvent extends ModeloEvent {
  final int marcaId;
  final TipoVeiculo tipo;

  const LoadModelosPorMarcaEvent({required this.marcaId, required this.tipo});

  @override
  List<Object?> get props => [marcaId, tipo];
}

/// Evento para buscar modelos por nome
class SearchModelosEvent extends ModeloEvent {
  final String query;

  const SearchModelosEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Evento para limpar a busca
class ClearSearchModelosEvent extends ModeloEvent {
  const ClearSearchModelosEvent();
}
