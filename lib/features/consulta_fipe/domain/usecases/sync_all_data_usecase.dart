import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/fipe_repository.dart';

/// UseCase para sincronizar todos os dados do servidor
///
/// Faz download completo de marcas e modelos da versão mais atual
/// e armazena localmente. Ideal para uso offline.
class SyncAllDataUseCase implements UseCase<void, SyncAllDataParams> {
  final FipeRepository repository;

  SyncAllDataUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SyncAllDataParams params) async {
    return await repository.syncAllData(
      onProgress: params.onProgress,
    );
  }
}

/// Parâmetros para sincronização de dados
class SyncAllDataParams extends Equatable {
  /// Callback para reportar progresso da sincronização
  final Function(String) onProgress;

  const SyncAllDataParams({required this.onProgress});

  @override
  List<Object?> get props => [onProgress];
}
