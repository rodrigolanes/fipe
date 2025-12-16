import 'package:equatable/equatable.dart';

import '../../domain/entities/modelo_entity.dart';

/// Estados do ModeloBloc
abstract class ModeloState extends Equatable {
  const ModeloState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class ModeloInitial extends ModeloState {
  const ModeloInitial();
}

/// Estado de carregamento
class ModeloLoading extends ModeloState {
  const ModeloLoading();
}

/// Estado de sucesso com lista de modelos
class ModeloLoaded extends ModeloState {
  final List<ModeloEntity> modelos;
  final List<ModeloEntity> filteredModelos;
  final String searchQuery;

  const ModeloLoaded({
    required this.modelos,
    required this.filteredModelos,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [modelos, filteredModelos, searchQuery];

  ModeloLoaded copyWith({
    List<ModeloEntity>? modelos,
    List<ModeloEntity>? filteredModelos,
    String? searchQuery,
  }) {
    return ModeloLoaded(
      modelos: modelos ?? this.modelos,
      filteredModelos: filteredModelos ?? this.filteredModelos,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Estado de erro
class ModeloError extends ModeloState {
  final String message;

  const ModeloError(this.message);

  @override
  List<Object?> get props => [message];
}
