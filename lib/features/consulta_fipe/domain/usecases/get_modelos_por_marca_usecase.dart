import 'package:dartz/dartz.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/modelo_entity.dart';
import '../repositories/fipe_repository.dart';

/// UseCase para buscar modelos por marca
///
/// Este caso de uso é responsável por recuperar todos os modelos disponíveis
/// para uma determinada marca e tipo de veículo.
///
/// Exemplo de uso:
/// ```dart
/// final result = await getModelosUseCase(GetModelosPorMarcaParams(
///   marcaId: 1,
///   tipo: TipoVeiculo.carro,
/// ));
/// result.fold(
///   (failure) => print('Erro: $failure'),
///   (modelos) => print('Modelos: $modelos'),
/// );
/// ```
class GetModelosPorMarcaUseCase
    implements UseCase<List<ModeloEntity>, GetModelosPorMarcaParams> {
  final FipeRepository repository;

  const GetModelosPorMarcaUseCase(this.repository);

  @override
  Future<Either<Failure, List<ModeloEntity>>> call(
    GetModelosPorMarcaParams params,
  ) async {
    return await repository.getModelosPorMarca(
      params.marcaId,
      params.tipo,
      ano: params.ano,
    );
  }
}

/// Parâmetros para o GetModelosPorMarcaUseCase
class GetModelosPorMarcaParams {
  final int marcaId;
  final TipoVeiculo tipo;
  final String? ano;

  const GetModelosPorMarcaParams({
    required this.marcaId,
    required this.tipo,
    this.ano,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetModelosPorMarcaParams &&
        other.marcaId == marcaId &&
        other.tipo == tipo;
  }

  @override
  int get hashCode => marcaId.hashCode ^ tipo.hashCode;
}
