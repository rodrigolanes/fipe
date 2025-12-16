import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ano_combustivel_entity.dart';
import '../repositories/fipe_repository.dart';

/// Use case para buscar anos disponíveis por marca
class GetAnosPorMarcaUseCase
    implements UseCase<List<AnoCombustivelEntity>, GetAnosPorMarcaParams> {
  final FipeRepository repository;

  GetAnosPorMarcaUseCase(this.repository);

  @override
  Future<Either<Failure, List<AnoCombustivelEntity>>> call(
    GetAnosPorMarcaParams params,
  ) async {
    return await repository.getAnosPorMarca(params.marcaId, params.tipo);
  }
}

class GetAnosPorMarcaParams extends Equatable {
  final int marcaId;
  final TipoVeiculo tipo;

  const GetAnosPorMarcaParams({required this.marcaId, required this.tipo});

  @override
  List<Object?> get props => [marcaId, tipo];
}
