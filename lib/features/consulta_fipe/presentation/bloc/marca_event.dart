import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_constants.dart';

/// Eventos do MarcaBloc
abstract class MarcaEvent extends Equatable {
  const MarcaEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para carregar marcas por tipo de veículo
class LoadMarcasPorTipoEvent extends MarcaEvent {
  final TipoVeiculo tipo;

  const LoadMarcasPorTipoEvent(this.tipo);

  @override
  List<Object?> get props => [tipo];
}

/// Evento para buscar marcas por nome
class SearchMarcasEvent extends MarcaEvent {
  final String query;

  const SearchMarcasEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Evento para limpar a busca
class ClearSearchMarcasEvent extends MarcaEvent {
  const ClearSearchMarcasEvent();
}
