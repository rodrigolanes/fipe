import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_for_updates_usecase.dart';
import '../../domain/usecases/get_local_mes_referencia_usecase.dart';
import '../../domain/usecases/sync_all_data_usecase.dart';

part 'sync_event.dart';
part 'sync_state.dart';

/// BLoC para gerenciar sincronização de dados
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final CheckForUpdatesUseCase checkForUpdates;
  final SyncAllDataUseCase syncAllData;
  final GetLocalMesReferenciaUseCase getLocalMesReferencia;

  SyncBloc({
    required this.checkForUpdates,
    required this.syncAllData,
    required this.getLocalMesReferencia,
  }) : super(const SyncInitial()) {
    on<CheckForUpdatesEvent>(_onCheckForUpdates);
    on<StartSyncEvent>(_onStartSync);
    on<CancelSyncEvent>(_onCancelSync);
  }

  Future<void> _onCheckForUpdates(
    CheckForUpdatesEvent event,
    Emitter<SyncState> emit,
  ) async {
    emit(const CheckingForUpdates());

    // Busca versão local
    final localResult = await getLocalMesReferencia(NoParams());
    String? currentVersion;

    localResult.fold(
      (failure) => currentVersion = null,
      (mesRef) => currentVersion = mesRef?.nomeFormatado,
    );

    // Verifica se há atualizações
    final result = await checkForUpdates(NoParams());

    result.fold(
      (failure) => emit(SyncError(message: _mapFailureToMessage(failure))),
      (hasUpdate) {
        if (hasUpdate) {
          emit(UpdateAvailable(
            currentVersion: currentVersion ?? 'Nenhum dado local',
            newVersion: 'Nova versão disponível',
          ));
        } else {
          emit(NoUpdateAvailable(
            currentVersion: currentVersion ?? 'Versão atual',
          ));
        }
      },
    );
  }

  Future<void> _onStartSync(
    StartSyncEvent event,
    Emitter<SyncState> emit,
  ) async {
    emit(const Syncing(progressMessage: 'Iniciando sincronização...'));

    final result = await syncAllData(
      SyncAllDataParams(
        onProgress: (message) {
          if (!isClosed) {
            emit(Syncing(progressMessage: message));
          }
        },
      ),
    );

    result.fold(
      (failure) => emit(SyncError(message: _mapFailureToMessage(failure))),
      (_) => emit(const SyncCompleted(
        message: 'Dados sincronizados com sucesso!',
      )),
    );
  }

  Future<void> _onCancelSync(
    CancelSyncEvent event,
    Emitter<SyncState> emit,
  ) async {
    emit(const SyncCancelled());
  }

  String _mapFailureToMessage(failure) {
    // Mapeia failures para mensagens amigáveis
    return failure.toString();
  }
}
