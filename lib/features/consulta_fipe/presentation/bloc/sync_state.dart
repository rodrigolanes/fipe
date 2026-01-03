part of 'sync_bloc.dart';

/// Estados do Sync BLoC
abstract class SyncState extends Equatable {
  const SyncState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class SyncInitial extends SyncState {
  const SyncInitial();
}

/// Verificando atualizações
class CheckingForUpdates extends SyncState {
  const CheckingForUpdates();
}

/// Atualização disponível
class UpdateAvailable extends SyncState {
  final String currentVersion;
  final String newVersion;

  const UpdateAvailable({
    required this.currentVersion,
    required this.newVersion,
  });

  @override
  List<Object?> get props => [currentVersion, newVersion];
}

/// Nenhuma atualização disponível
class NoUpdateAvailable extends SyncState {
  final String currentVersion;

  const NoUpdateAvailable({required this.currentVersion});

  @override
  List<Object?> get props => [currentVersion];
}

/// Sincronizando dados
class Syncing extends SyncState {
  final String progressMessage;
  final double? progress; // 0.0 a 1.0, null se indeterminado

  const Syncing({
    required this.progressMessage,
    this.progress,
  });

  @override
  List<Object?> get props => [progressMessage, progress];
}

/// Sincronização concluída
class SyncCompleted extends SyncState {
  final String message;

  const SyncCompleted({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Sincronização cancelada
class SyncCancelled extends SyncState {
  const SyncCancelled();
}

/// Erro na verificação ou sincronização
class SyncError extends SyncState {
  final String message;

  const SyncError({required this.message});

  @override
  List<Object?> get props => [message];
}
