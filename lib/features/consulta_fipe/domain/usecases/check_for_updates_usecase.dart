import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/fipe_repository.dart';

/// UseCase para verificar se há atualizações disponíveis
///
/// Compara o mês de referência local com o do servidor
/// e retorna true se houver uma versão mais recente disponível.
class CheckForUpdatesUseCase implements UseCase<bool, NoParams> {
  final FipeRepository repository;

  CheckForUpdatesUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.checkForUpdates();
  }
}
