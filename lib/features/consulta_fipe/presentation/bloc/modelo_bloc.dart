import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_modelos_por_marca_usecase.dart';
import 'modelo_event.dart';
import 'modelo_state.dart';

/// BLoC para gerenciar o estado dos modelos
class ModeloBloc extends Bloc<ModeloEvent, ModeloState> {
  final GetModelosPorMarcaUseCase getModelosPorMarca;

  ModeloBloc({required this.getModelosPorMarca})
    : super(const ModeloInitial()) {
    on<LoadModelosPorMarcaEvent>(_onLoadModelosPorMarca);
    on<SearchModelosEvent>(_onSearchModelos);
    on<ClearSearchModelosEvent>(_onClearSearch);
  }

  Future<void> _onLoadModelosPorMarca(
    LoadModelosPorMarcaEvent event,
    Emitter<ModeloState> emit,
  ) async {
    emit(const ModeloLoading());

    final result = await getModelosPorMarca(
      GetModelosPorMarcaParams(marcaId: event.marcaId, tipo: event.tipo),
    );

    result.fold(
      (failure) => emit(ModeloError(_mapFailureToMessage(failure))),
      (modelos) =>
          emit(ModeloLoaded(modelos: modelos, filteredModelos: modelos)),
    );
  }

  void _onSearchModelos(SearchModelosEvent event, Emitter<ModeloState> emit) {
    if (state is ModeloLoaded) {
      final currentState = state as ModeloLoaded;
      final query = event.query.toLowerCase();

      if (query.isEmpty) {
        emit(
          currentState.copyWith(
            filteredModelos: currentState.modelos,
            searchQuery: '',
          ),
        );
      } else {
        final filtered = currentState.modelos
            .where((modelo) => modelo.nome.toLowerCase().contains(query))
            .toList();

        emit(
          currentState.copyWith(
            filteredModelos: filtered,
            searchQuery: event.query,
          ),
        );
      }
    }
  }

  void _onClearSearch(
    ClearSearchModelosEvent event,
    Emitter<ModeloState> emit,
  ) {
    if (state is ModeloLoaded) {
      final currentState = state as ModeloLoaded;
      emit(
        currentState.copyWith(
          filteredModelos: currentState.modelos,
          searchQuery: '',
        ),
      );
    }
  }

  String _mapFailureToMessage(failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return 'Erro ao buscar modelos no servidor';
      case const (CacheFailure):
        return 'Erro ao carregar dados do cache';
      case const (NetworkFailure):
        return 'Sem conexão com a internet';
      default:
        return 'Erro inesperado';
    }
  }
}
