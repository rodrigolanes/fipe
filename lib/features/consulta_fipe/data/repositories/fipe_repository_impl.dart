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
      // Busca sempre remotamente (sem cache)
      final marcas = await remoteDataSource.getMarcasByTipo(tipo);
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
      // Busca sempre remotamente (sem cache)
      final modelos = await remoteDataSource.getModelosByMarca(
        marcaId,
        tipo,
        ano: ano,
      );
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
      // Busca sempre remotamente (sem cache)
      final valor = await remoteDataSource.getValorFipe(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      );
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
