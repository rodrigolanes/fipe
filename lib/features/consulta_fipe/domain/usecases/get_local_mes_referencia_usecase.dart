import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/mes_referencia_entity.dart';
import '../repositories/fipe_repository.dart';

/// UseCase para buscar o mês de referência armazenado localmente
///
/// Retorna informações sobre a versão dos dados FIPE
/// atualmente armazenados no dispositivo.
class GetLocalMesReferenciaUseCase
    implements UseCase<MesReferenciaEntity?, NoParams> {
  final FipeRepository repository;

  GetLocalMesReferenciaUseCase(this.repository);

  @override
  Future<Either<Failure, MesReferenciaEntity?>> call(NoParams params) async {
    return await repository.getLocalMesReferencia();
  }
}
