import 'dart:async';

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
import '../models/marca_model.dart';

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
      // Tenta buscar do cache primeiro (marcas são dados estáveis)
      final cacheKey = 'marcas_${tipo.nome}';
      final isCacheValid = await localDataSource.isCacheValid(cacheKey);

      if (isCacheValid) {
        try {
          final cachedMarcas = await localDataSource.getCachedMarcas(tipo);
          if (cachedMarcas.isNotEmpty) {
            return Right(cachedMarcas);
          }
        } on CacheException {
          // Se falhar, continua para buscar remotamente
        }
      }

      // Busca remota
      final marcas = await remoteDataSource.getMarcasByTipo(tipo);

      // Tenta salvar em cache (opcional - não deve falhar a operação)
      try {
        await localDataSource.cacheMarcas(marcas, tipo);
      } catch (e) {
        // Não falha se cache falhar
      }

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
    TipoVeiculo tipo, {
    String? ano,
  }) async {
    try {
      // Tenta buscar do cache primeiro (apenas se não houver filtro de ano)
      if (ano == null) {
        final cacheKey = 'modelos_$marcaId';
        final isCacheValid = await localDataSource.isCacheValid(cacheKey);

        if (isCacheValid) {
          try {
            final cachedModelos = await localDataSource.getCachedModelos(
              marcaId,
            );
            if (cachedModelos.isNotEmpty) {
              return Right(cachedModelos);
            }
          } on CacheException {
            // Se falhar, continua para buscar remotamente
          }
        }
      }

      // Busca remota
      final modelos = await remoteDataSource.getModelosByMarca(
        marcaId,
        tipo,
        ano: ano,
      );

      // Tenta salvar em cache (apenas se não houver filtro de ano)
      if (ano == null) {
        try {
          await localDataSource.cacheModelos(modelos, marcaId);
        } catch (e) {
          // Não falha se cache falhar
        }
      }

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
      // Anos e combustíveis são sempre buscados remotamente (dados dinâmicos)
      final anosCombustiveis =
          await remoteDataSource.getAnosCombustiveisByModelo(modeloId, tipo);

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
  Future<Either<Failure, List<AnoCombustivelEntity>>> getAnosPorMarca(
    int marcaId,
    TipoVeiculo tipo,
  ) async {
    try {
      // Busca anos disponíveis para a marca
      final anosCombustiveis = await remoteDataSource.getAnosPorMarca(
        marcaId,
        tipo,
      );

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
      // Busca mês de referência atual do servidor
      final mesReferencia = await remoteDataSource.getUltimoMesReferencia();

      // Mapeia combustível para código
      final codigoCombustivel = _getCombustivelCodigo(combustivel);
      final anoModelo = int.parse(ano);

      // ESTRATÉGIA: Cache temporário (5 min) com validação de mês
      // 1. Verifica cache local (válido + mesmo mês)
      final valorCache = await localDataSource.getValorFipeFromCache(
        marcaId: marcaId,
        modeloId: modeloId,
        anoModelo: anoModelo,
        codigoCombustivel: codigoCombustivel,
        tipoVeiculo: tipo.codigo,
        mesReferencia: mesReferencia,
      );

      if (valorCache != null) {
        return Right(valorCache);
      }

      // 2. Se cache inválido/expirado, busca do servidor
      final valor = await remoteDataSource.getValorFipe(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      );

      // 3. Salva no cache temporário
      try {
        await localDataSource.cacheValorFipeTemp(valor, mesReferencia);
      } catch (e) {
        // Não falha se cache falhar
      }

      return Right(valor);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: ${e.toString()}'));
    }
  }

  /// Mapeia nome do combustível para código numérico
  int _getCombustivelCodigo(String combustivel) {
    final combustivelLower = combustivel.toLowerCase();
    if (combustivelLower.contains('gasolina')) return 1;
    if (combustivelLower.contains('álcool') ||
        combustivelLower.contains('etanol')) {
      return 2;
    }
    if (combustivelLower.contains('diesel')) return 3;
    if (combustivelLower.contains('elétrico') ||
        combustivelLower.contains('eletrico')) {
      return 4;
    }
    if (combustivelLower.contains('flex')) return 5;
    if (combustivelLower.contains('híbrido') ||
        combustivelLower.contains('hibrido')) {
      return 6;
    }
    if (combustivelLower.contains('gás') || combustivelLower.contains('gnv')) {
      return 7;
    }
    return 1; // Default: Gasolina
  }
}
