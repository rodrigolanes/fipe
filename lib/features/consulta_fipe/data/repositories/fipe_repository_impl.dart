import 'package:dartz/dartz.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/ano_combustivel_entity.dart';
import '../../domain/entities/marca_entity.dart';
import '../../domain/entities/modelo_entity.dart';
import '../../domain/entities/valor_fipe_entity.dart';
import '../../domain/repositories/fipe_repository.dart';
import '../datasources/fipe_local_data_source.dart';
import '../datasources/fipe_remote_data_source.dart';

class FipeRepositoryImpl implements FipeRepository {
  final FipeRemoteDataSource remoteDataSource;
  final FipeLocalDataSource localDataSource;

  FipeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<MarcaEntity>>> getMarcasPorTipo(
    TipoVeiculo tipo,
  ) async {
    try {
      // Tenta buscar do cache primeiro
      final cacheKey = 'marcas_${tipo.nome}';
      final isCacheValid = await localDataSource.isCacheValid(cacheKey);

      if (isCacheValid) {
        try {
          final cachedMarcas = await localDataSource.getCachedMarcas(tipo);
          return Right(cachedMarcas);
        } on CacheException {
          // Se falhar, continua para buscar remotamente
        }
      }

      // Busca remota
      final marcas = await remoteDataSource.getMarcasByTipo(tipo);

      // Salva em cache
      await localDataSource.cacheMarcas(marcas, tipo);

      return Right(marcas);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ModeloEntity>>> getModelosPorMarca(
    int marcaId,
    TipoVeiculo tipo,
  ) async {
    try {
      // Tenta buscar do cache primeiro
      final cacheKey = 'modelos_$marcaId';
      final isCacheValid = await localDataSource.isCacheValid(cacheKey);

      if (isCacheValid) {
        try {
          final cachedModelos = await localDataSource.getCachedModelos(marcaId);
          return Right(cachedModelos);
        } on CacheException {
          // Se falhar, continua para buscar remotamente
        }
      }

      // Busca remota
      final modelos = await remoteDataSource.getModelosByMarca(marcaId, tipo);

      // Salva em cache
      await localDataSource.cacheModelos(modelos, marcaId);

      return Right(modelos);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<AnoCombustivelEntity>>>
  getAnosCombustiveisPorModelo(int modeloId, TipoVeiculo tipo) async {
    try {
      // Anos e combustíveis são buscados sempre remotamente (dados mais dinâmicos)
      final anosCombustiveis = await remoteDataSource
          .getAnosCombustiveisByModelo(modeloId, tipo);

      return Right(anosCombustiveis);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ValorFipeEntity>> getValorFipe({
    required int marcaId,
    required int modeloId,
    required String ano,
    required String combustivel,
    required TipoVeiculo tipo,
  }) async {
    try {
      // Busca valor FIPE sempre remotamente (dados atualizados)
      final valor = await remoteDataSource.getValorFipe(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      );

      // Salva em cache para histórico
      await localDataSource.cacheValorFipe(valor);

      return Right(valor);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: ${e.toString()}'));
    }
  }
}
