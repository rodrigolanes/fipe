import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_anos_combustiveis_por_modelo_usecase.dart';
import '../../domain/usecases/get_anos_por_marca_usecase.dart';
import 'ano_combustivel_event.dart';
import 'ano_combustivel_state.dart';

/// BLoC para gerenciar o estado dos anos e combustíveis
class AnoCombustivelBloc
    extends Bloc<AnoCombustivelEvent, AnoCombustivelState> {
  final GetAnosCombustiveisPorModeloUseCase getAnosCombustiveisPorModelo;
  final GetAnosPorMarcaUseCase getAnosPorMarca;

  AnoCombustivelBloc({
    required this.getAnosCombustiveisPorModelo,
    required this.getAnosPorMarca,
  }) : super(const AnoCombustivelInitial()) {
    on<LoadAnosCombustiveisPorModeloEvent>(_onLoadAnosCombustiveisPorModelo);
    on<LoadAnosPorMarcaEvent>(_onLoadAnosPorMarca);
  }

  Future<void> _onLoadAnosCombustiveisPorModelo(
    LoadAnosCombustiveisPorModeloEvent event,
    Emitter<AnoCombustivelState> emit,
  ) async {
    emit(const AnoCombustivelLoading());

    final result = await getAnosCombustiveisPorModelo(
      GetAnosCombustiveisPorModeloParams(
        modeloId: event.modeloId,
        tipo: event.tipo,
      ),
    );

    result.fold(
      (failure) => emit(AnoCombustivelError(_mapFailureToMessage(failure))),
      (anosCombustiveis) => emit(AnoCombustivelLoaded(anosCombustiveis)),
    );
  }

  Future<void> _onLoadAnosPorMarca(
    LoadAnosPorMarcaEvent event,
    Emitter<AnoCombustivelState> emit,
  ) async {
    emit(const AnoCombustivelLoading());

    final result = await getAnosPorMarca(
      GetAnosPorMarcaParams(marcaId: event.marcaId, tipo: event.tipo),
    );

    result.fold(
      (failure) => emit(AnoCombustivelError(_mapFailureToMessage(failure))),
      (anosCombustiveis) => emit(AnoCombustivelLoaded(anosCombustiveis)),
    );
  }

  String _mapFailureToMessage(failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return 'Erro ao buscar anos e combustíveis no servidor';
      case const (CacheFailure):
        return 'Erro ao carregar dados do cache';
      case const (NetworkFailure):
        return 'Sem conexão com a internet';
      default:
        return 'Erro inesperado';
    }
  }
}
