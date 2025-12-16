import 'package:equatable/equatable.dart';

import '../../domain/entities/ano_combustivel_entity.dart';

/// Estados do AnoCombustivelBloc
abstract class AnoCombustivelState extends Equatable {
  const AnoCombustivelState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class AnoCombustivelInitial extends AnoCombustivelState {
  const AnoCombustivelInitial();
}

/// Estado de carregamento
class AnoCombustivelLoading extends AnoCombustivelState {
  const AnoCombustivelLoading();
}

/// Estado de sucesso com lista de anos e combustíveis
class AnoCombustivelLoaded extends AnoCombustivelState {
  final List<AnoCombustivelEntity> anosCombustiveis;

  const AnoCombustivelLoaded(this.anosCombustiveis);

  @override
  List<Object?> get props => [anosCombustiveis];
}

/// Estado de erro
class AnoCombustivelError extends AnoCombustivelState {
  final String message;

  const AnoCombustivelError(this.message);

  @override
  List<Object?> get props => [message];
}
