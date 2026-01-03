import 'package:dartz/dartz.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ano_combustivel_entity.dart';
import '../repositories/fipe_repository.dart';

/// UseCase para buscar anos e combustíveis por modelo
///
/// Este caso de uso é responsável por recuperar todos os anos e tipos de
/// combustível disponíveis para um determinado modelo de veículo.
///
/// Exemplo de uso:
/// ```dart
/// final result = await getAnosCombustiveisUseCase(GetAnosCombustiveisPorModeloParams(
///   modeloId: 123,
///   tipo: TipoVeiculo.carro,
/// ));
/// result.fold(
///   (failure) => print('Erro: $failure'),
///   (anosCombustiveis) => print('Anos: $anosCombustiveis'),
/// );
/// ```
class GetAnosCombustiveisPorModeloUseCase
    implements
        UseCase<List<AnoCombustivelEntity>,
            GetAnosCombustiveisPorModeloParams> {
  final FipeRepository repository;

  const GetAnosCombustiveisPorModeloUseCase(this.repository);

  @override
  Future<Either<Failure, List<AnoCombustivelEntity>>> call(
    GetAnosCombustiveisPorModeloParams params,
  ) async {
    return await repository.getAnosCombustiveisPorModelo(
      params.modeloId,
      params.tipo,
    );
  }
}

/// Parâmetros para o GetAnosCombustiveisPorModeloUseCase
class GetAnosCombustiveisPorModeloParams {
  final int modeloId;
  final TipoVeiculo tipo;

  const GetAnosCombustiveisPorModeloParams({
    required this.modeloId,
    required this.tipo,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetAnosCombustiveisPorModeloParams &&
        other.modeloId == modeloId &&
        other.tipo == tipo;
  }

  @override
  int get hashCode => modeloId.hashCode ^ tipo.hashCode;
}
