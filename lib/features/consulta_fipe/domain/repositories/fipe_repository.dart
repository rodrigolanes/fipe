import 'package:dartz/dartz.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/ano_combustivel_entity.dart';
import '../../domain/entities/marca_entity.dart';
import '../../domain/entities/modelo_entity.dart';
import '../../domain/entities/valor_fipe_entity.dart';

/// Interface do repositório FIPE (Domain Layer)
abstract class FipeRepository {
  /// Busca marcas por tipo de veículo
  Future<Either<Failure, List<MarcaEntity>>> getMarcasPorTipo(TipoVeiculo tipo);

  /// Busca modelos por marca
  Future<Either<Failure, List<ModeloEntity>>> getModelosPorMarca(
    int marcaId,
    TipoVeiculo tipo,
  );

  /// Busca anos e combustíveis disponíveis para um modelo
  Future<Either<Failure, List<AnoCombustivelEntity>>>
  getAnosCombustiveisPorModelo(int modeloId, TipoVeiculo tipo);

  /// Busca o valor FIPE de um veículo específico
  Future<Either<Failure, ValorFipeEntity>> getValorFipe({
    required int marcaId,
    required int modeloId,
    required String ano,
    required String combustivel,
    required TipoVeiculo tipo,
  });
}
