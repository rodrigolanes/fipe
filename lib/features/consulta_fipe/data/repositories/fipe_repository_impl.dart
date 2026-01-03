import 'package:dartz/dartz.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/ano_combustivel_entity.dart';
import '../../domain/entities/marca_entity.dart';
import '../../domain/entities/mes_referencia_entity.dart';
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
            return Right(cachedModelos);
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

      // Salva em cache (apenas se não houver filtro de ano)
      if (ano == null) {
        await localDataSource.cacheModelos(modelos, marcaId);
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
      // Anos e combustíveis são buscados sempre remotamente (dados mais dinâmicos)
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
      // Gera chave única para este valor específico
      final codigoFipeKey =
          '${tipo.codigo}_${marcaId}_${modeloId}_${ano}_$combustivel';

      // Tenta buscar do cache primeiro
      final cacheKey = 'valor_$codigoFipeKey';
      final isCacheValid = await localDataSource.isCacheValid(cacheKey);

      if (isCacheValid) {
        try {
          // Busca valor do cache
          final cachedValor =
              await localDataSource.getCachedValorFipe(codigoFipeKey);

          if (cachedValor != null) {
            // Verifica se o mês de referência ainda é o atual
            final mesLocal = await localDataSource.getLocalMesReferencia();

            // Se o cache tem o mesmo mês de referência, usa ele
            if (mesLocal != null &&
                cachedValor.mesReferencia == mesLocal.id) {
              return Right(cachedValor);
            }
            // Se o mês mudou, continua para buscar remotamente
          }
        } on CacheException {
          // Se falhar, continua para buscar remotamente
        }
      }

      // Busca valor FIPE remotamente
      final valor = await remoteDataSource.getValorFipe(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      );

      // Salva em cache com a chave customizada
      await localDataSource.cacheValorFipe(valor, codigoFipeKey);

      return Right(valor);
    } on ServerException catch (e) {
      // Em caso de erro de servidor, tenta retornar do cache mesmo que expirado
      try {
        final codigoFipeKey =
            '${tipo.codigo}_${marcaId}_${modeloId}_${ano}_$combustivel';
        final cachedValor =
            await localDataSource.getCachedValorFipe(codigoFipeKey);

        if (cachedValor != null) {
          // Retorna cache mesmo expirado como fallback offline
          return Right(cachedValor);
        }
      } on CacheException {
        // Ignora erro de cache e retorna o erro original do servidor
      }

      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      // Tenta usar cache offline em caso de erro de rede
      try {
        final codigoFipeKey =
            '${tipo.codigo}_${marcaId}_${modeloId}_${ano}_$combustivel';
        final cachedValor =
            await localDataSource.getCachedValorFipe(codigoFipeKey);

        if (cachedValor != null) {
          return Right(cachedValor);
        }
      } on CacheException {
        // Ignora erro de cache e retorna o erro original de rede
      }

      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro desconhecido: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkForUpdates() async {
    try {
      // Busca o mês de referência mais atual do servidor
      final mesRemoto = await remoteDataSource.getUltimoMesReferencia();

      // Busca o mês de referência armazenado localmente
      final mesLocal = await localDataSource.getLocalMesReferencia();

      // Se não há dados locais, precisa sincronizar
      if (mesLocal == null) {
        return const Right(true);
      }

      // Compara se o mês remoto é mais recente que o local
      final hasUpdate = mesRemoto.isNewerThan(mesLocal);

      return Right(hasUpdate);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(
          ServerFailure('Erro ao verificar atualizações: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> syncAllData({
    required Function(String) onProgress,
  }) async {
    try {
      onProgress('Verificando versão mais recente...');

      // Busca o mês de referência mais atual
      final mesReferencia = await remoteDataSource.getUltimoMesReferencia();

      onProgress('Baixando marcas...');

      // Busca todas as marcas
      final todasMarcas = await remoteDataSource.getAllMarcas();

      onProgress('Salvando ${todasMarcas.length} marcas...');

      // Salva todas as marcas localmente
      await localDataSource.saveAllMarcas(todasMarcas);

      // Opcional: Sincronizar modelos (comentado pois pode ser muito pesado)
      // Para cada marca, baixar todos os modelos seria muito demorado
      // Melhor manter o cache sob demanda apenas

      onProgress('Salvando informação de versão...');

      // Salva o mês de referência atualizado
      await localDataSource.saveMesReferencia(mesReferencia);

      onProgress('Sincronização concluída!');

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro ao sincronizar dados: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, MesReferenciaEntity?>> getLocalMesReferencia() async {
    try {
      final mesReferencia = await localDataSource.getLocalMesReferencia();
      return Right(mesReferencia);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(
          'Erro ao buscar mês de referência local: ${e.toString()}'));
    }
  }
}
