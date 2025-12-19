import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/get_marcas_por_tipo_usecase.dart';
import 'marca_event.dart';
import 'marca_state.dart';

/// BLoC para gerenciar o estado das marcas
class MarcaBloc extends Bloc<MarcaEvent, MarcaState> {
  final GetMarcasPorTipoUseCase getMarcasPorTipo;

  MarcaBloc({required this.getMarcasPorTipo}) : super(const MarcaInitial()) {
    on<LoadMarcasPorTipoEvent>(_onLoadMarcasPorTipo);
    on<SearchMarcasEvent>(_onSearchMarcas);
    on<ClearSearchMarcasEvent>(_onClearSearch);
  }

  Future<void> _onLoadMarcasPorTipo(
    LoadMarcasPorTipoEvent event,
    Emitter<MarcaState> emit,
  ) async {
    emit(const MarcaLoading());

    AppLogger.d('Carregando marcas para tipo: ${event.tipo}');

    final result = await getMarcasPorTipo(
      GetMarcasPorTipoParams(tipo: event.tipo),
    );

    result.fold(
      (failure) {
        AppLogger.e('Erro ao carregar marcas', failure);
        emit(MarcaError(_mapFailureToMessage(failure)));
      },
      (marcas) {
        AppLogger.i('${marcas.length} marcas carregadas com sucesso');
        emit(MarcaLoaded(marcas: marcas, filteredMarcas: marcas));
      },
    );
  }

  void _onSearchMarcas(SearchMarcasEvent event, Emitter<MarcaState> emit) {
    if (state is MarcaLoaded) {
      final currentState = state as MarcaLoaded;
      final query = event.query.toLowerCase();

      if (query.isEmpty) {
        emit(
          currentState.copyWith(
            filteredMarcas: currentState.marcas,
            searchQuery: '',
          ),
        );
      } else {
        final filtered = currentState.marcas
            .where((marca) => marca.nome.toLowerCase().contains(query))
            .toList();

        emit(
          currentState.copyWith(
            filteredMarcas: filtered,
            searchQuery: event.query,
          ),
        );
      }
    }
  }

  void _onClearSearch(ClearSearchMarcasEvent event, Emitter<MarcaState> emit) {
    if (state is MarcaLoaded) {
      final currentState = state as MarcaLoaded;
      emit(
        currentState.copyWith(
          filteredMarcas: currentState.marcas,
          searchQuery: '',
        ),
      );
    }
  }

  String _mapFailureToMessage(failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return 'Erro ao buscar marcas no servidor';
      case const (CacheFailure):
        return 'Erro ao carregar dados do cache';
      case const (NetworkFailure):
        return 'Sem conexão com a internet';
      default:
        return 'Erro inesperado';
    }
  }
}
