import 'package:equatable/equatable.dart';

import '../../domain/entities/marca_entity.dart';

/// Estados do MarcaBloc
abstract class MarcaState extends Equatable {
  const MarcaState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class MarcaInitial extends MarcaState {
  const MarcaInitial();
}

/// Estado de carregamento
class MarcaLoading extends MarcaState {
  const MarcaLoading();
}

/// Estado de sucesso com lista de marcas
class MarcaLoaded extends MarcaState {
  final List<MarcaEntity> marcas;
  final List<MarcaEntity> filteredMarcas;
  final String searchQuery;

  const MarcaLoaded({
    required this.marcas,
    required this.filteredMarcas,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [marcas, filteredMarcas, searchQuery];

  MarcaLoaded copyWith({
    List<MarcaEntity>? marcas,
    List<MarcaEntity>? filteredMarcas,
    String? searchQuery,
  }) {
    return MarcaLoaded(
      marcas: marcas ?? this.marcas,
      filteredMarcas: filteredMarcas ?? this.filteredMarcas,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Estado de erro
class MarcaError extends MarcaState {
  final String message;

  const MarcaError(this.message);

  @override
  List<Object?> get props => [message];
}
