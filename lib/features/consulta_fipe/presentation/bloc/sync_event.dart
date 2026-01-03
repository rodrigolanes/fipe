part of 'sync_bloc.dart';

/// Eventos do Sync BLoC
abstract class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para verificar se há atualizações disponíveis
class CheckForUpdatesEvent extends SyncEvent {
  const CheckForUpdatesEvent();
}

/// Evento para iniciar sincronização de dados
class StartSyncEvent extends SyncEvent {
  const StartSyncEvent();
}

/// Evento para cancelar sincronização
class CancelSyncEvent extends SyncEvent {
  const CancelSyncEvent();
}
