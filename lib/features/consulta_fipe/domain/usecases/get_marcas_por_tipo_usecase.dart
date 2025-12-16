import 'package:dartz/dartz.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/marca_entity.dart';
import '../repositories/fipe_repository.dart';

/// UseCase para buscar marcas por tipo de veículo
///
/// Este caso de uso é responsável por recuperar todas as marcas disponíveis
/// para um determinado tipo de veículo (carro, moto ou caminhão).
///
/// Exemplo de uso:
/// ```dart
/// final result = await getMarcasUseCase(GetMarcasPorTipoParams(tipo: TipoVeiculo.carro));
/// result.fold(
///   (failure) => print('Erro: $failure'),
///   (marcas) => print('Marcas: $marcas'),
/// );
/// ```
class GetMarcasPorTipoUseCase
    implements UseCase<List<MarcaEntity>, GetMarcasPorTipoParams> {
  final FipeRepository repository;

  const GetMarcasPorTipoUseCase(this.repository);

  @override
  Future<Either<Failure, List<MarcaEntity>>> call(
    GetMarcasPorTipoParams params,
  ) async {
    return await repository.getMarcasPorTipo(params.tipo);
  }
}

/// Parâmetros para o GetMarcasPorTipoUseCase
class GetMarcasPorTipoParams {
  final TipoVeiculo tipo;

  const GetMarcasPorTipoParams({required this.tipo});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetMarcasPorTipoParams && other.tipo == tipo;
  }

  @override
  int get hashCode => tipo.hashCode;
}
