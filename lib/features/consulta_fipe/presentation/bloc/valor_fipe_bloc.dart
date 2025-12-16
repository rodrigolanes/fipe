import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_valor_fipe_usecase.dart';
import 'valor_fipe_event.dart';
import 'valor_fipe_state.dart';

/// BLoC para gerenciar o estado do valor FIPE
class ValorFipeBloc extends Bloc<ValorFipeEvent, ValorFipeState> {
  final GetValorFipeUseCase getValorFipe;

  ValorFipeBloc({required this.getValorFipe})
    : super(const ValorFipeInitial()) {
    on<LoadValorFipeEvent>(_onLoadValorFipe);
  }

  Future<void> _onLoadValorFipe(
    LoadValorFipeEvent event,
    Emitter<ValorFipeState> emit,
  ) async {
    emit(const ValorFipeLoading());

    final result = await getValorFipe(
      GetValorFipeParams(
        marcaId: event.marcaId,
        modeloId: event.modeloId,
        ano: event.ano,
        combustivel: event.combustivel,
        tipo: event.tipo,
      ),
    );

    result.fold(
      (failure) => emit(ValorFipeError(_mapFailureToMessage(failure))),
      (valorFipe) => emit(ValorFipeLoaded(valorFipe)),
    );
  }

  String _mapFailureToMessage(failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return 'Erro ao buscar valor FIPE no servidor';
      case const (CacheFailure):
        return 'Erro ao carregar dados do cache';
      case const (NetworkFailure):
        return 'Sem conexão com a internet';
      case const (NotFoundFailure):
        return 'Valor FIPE não encontrado';
      default:
        return 'Erro inesperado';
    }
  }
}
