import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:fipe/core/constants/app_constants.dart';
import 'package:fipe/core/error/exceptions.dart';
import 'package:fipe/core/error/failures.dart';
import 'package:fipe/features/consulta_fipe/data/repositories/fipe_repository_impl.dart';

import '../../../../fixtures/ano_combustivel_fixture.dart';
import '../../../../fixtures/marca_fixture.dart';
import '../../../../fixtures/modelo_fixture.dart';
import '../../../../fixtures/valor_fipe_fixture.dart';
import '../../../../helpers/mock_generator.mocks.dart';

void main() {
  late FipeRepositoryImpl repository;
  late MockFipeRemoteDataSource mockRemoteDataSource;
  late MockFipeLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockFipeRemoteDataSource();
    mockLocalDataSource = MockFipeLocalDataSource();
    repository = FipeRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('getMarcasPorTipo', () {
    const tipo = TipoVeiculo.carro;

    test('deve retornar marcas do cache quando disponível e válido', () async {
      // Arrange
      when(mockLocalDataSource.isCacheValid('marcas_${tipo.nome}'))
          .thenAnswer((_) async => true);
      when(mockLocalDataSource.getCachedMarcas(tipo))
          .thenAnswer((_) async => MarcaFixture.marcasModelList);

      // Act
      final result = await repository.getMarcasPorTipo(tipo);

      // Assert
      expect(result, equals(Right(MarcaFixture.marcasModelList)));
      verify(mockLocalDataSource.isCacheValid('marcas_${tipo.nome}'));
      verify(mockLocalDataSource.getCachedMarcas(tipo));
      verifyNever(mockRemoteDataSource.getMarcasByTipo(any));
    });

    test('deve buscar remotamente quando cache inválido', () async {
      // Arrange
      when(mockLocalDataSource.isCacheValid('marcas_${tipo.nome}'))
          .thenAnswer((_) async => false);
      when(mockRemoteDataSource.getMarcasByTipo(tipo))
          .thenAnswer((_) async => MarcaFixture.marcasModelList);
      when(mockLocalDataSource.cacheMarcas(any, any))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.getMarcasPorTipo(tipo);

      // Assert
      expect(result, equals(Right(MarcaFixture.marcasModelList)));
      verify(mockRemoteDataSource.getMarcasByTipo(tipo));
      verify(mockLocalDataSource.cacheMarcas(
        MarcaFixture.marcasModelList,
        tipo,
      ));
    });

    test('deve buscar remotamente quando cache lança CacheException', () async {
      // Arrange
      when(mockLocalDataSource.isCacheValid('marcas_${tipo.nome}'))
          .thenAnswer((_) async => true);
      when(mockLocalDataSource.getCachedMarcas(tipo))
          .thenThrow(CacheException('Cache error'));
      when(mockRemoteDataSource.getMarcasByTipo(tipo))
          .thenAnswer((_) async => MarcaFixture.marcasModelList);
      when(mockLocalDataSource.cacheMarcas(any, any))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.getMarcasPorTipo(tipo);

      // Assert
      expect(result, equals(Right(MarcaFixture.marcasModelList)));
      verify(mockRemoteDataSource.getMarcasByTipo(tipo));
    });

    test('deve retornar ServerFailure quando remoto lança ServerException',
        () async {
      // Arrange
      when(mockLocalDataSource.isCacheValid('marcas_${tipo.nome}'))
          .thenAnswer((_) async => false);
      when(mockRemoteDataSource.getMarcasByTipo(tipo))
          .thenThrow(ServerException('Server error'));

      // Act
      final result = await repository.getMarcasPorTipo(tipo);

      // Assert
      expect(result, equals(Left(ServerFailure('Server error'))));
    });

    test('deve retornar NetworkFailure quando remoto lança NetworkException',
        () async {
      // Arrange
      when(mockLocalDataSource.isCacheValid('marcas_${tipo.nome}'))
          .thenAnswer((_) async => false);
      when(mockRemoteDataSource.getMarcasByTipo(tipo))
          .thenThrow(NetworkException('Network error'));

      // Act
      final result = await repository.getMarcasPorTipo(tipo);

      // Assert
      expect(result, equals(Left(NetworkFailure('Network error'))));
    });
  });

  group('getModelosPorMarca', () {
    const marcaId = 1;
    const tipo = TipoVeiculo.carro;

    test('deve retornar modelos do cache quando disponível e sem filtro de ano',
        () async {
      // Arrange
      when(mockLocalDataSource.isCacheValid('modelos_$marcaId'))
          .thenAnswer((_) async => true);
      when(mockLocalDataSource.getCachedModelos(marcaId))
          .thenAnswer((_) async => ModeloFixture.modelosModelList);

      // Act
      final result = await repository.getModelosPorMarca(marcaId, tipo);

      // Assert
      expect(result, equals(Right(ModeloFixture.modelosModelList)));
      verify(mockLocalDataSource.isCacheValid('modelos_$marcaId'));
      verify(mockLocalDataSource.getCachedModelos(marcaId));
      verifyNever(mockRemoteDataSource.getModelosByMarca(any, any,
          ano: anyNamed('ano')));
    });

    test('deve buscar remotamente quando há filtro de ano', () async {
      // Arrange
      const ano = '2024';
      when(mockRemoteDataSource.getModelosByMarca(marcaId, tipo, ano: ano))
          .thenAnswer((_) async => ModeloFixture.modelosModelList);

      // Act
      final result =
          await repository.getModelosPorMarca(marcaId, tipo, ano: ano);

      // Assert
      expect(result, equals(Right(ModeloFixture.modelosModelList)));
      verify(mockRemoteDataSource.getModelosByMarca(marcaId, tipo, ano: ano));
      verifyNever(mockLocalDataSource.isCacheValid(any));
      verifyNever(mockLocalDataSource.cacheModelos(any, any));
    });

    test('deve buscar remotamente quando cache inválido', () async {
      // Arrange
      when(mockLocalDataSource.isCacheValid('modelos_$marcaId'))
          .thenAnswer((_) async => false);
      when(mockRemoteDataSource.getModelosByMarca(marcaId, tipo, ano: null))
          .thenAnswer((_) async => ModeloFixture.modelosModelList);
      when(mockLocalDataSource.cacheModelos(any, any))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.getModelosPorMarca(marcaId, tipo);

      // Assert
      expect(result, equals(Right(ModeloFixture.modelosModelList)));
      verify(mockRemoteDataSource.getModelosByMarca(marcaId, tipo, ano: null));
      verify(mockLocalDataSource.cacheModelos(
        ModeloFixture.modelosModelList,
        marcaId,
      ));
    });

    test('deve retornar ServerFailure quando remoto lança ServerException',
        () async {
      // Arrange
      when(mockLocalDataSource.isCacheValid('modelos_$marcaId'))
          .thenAnswer((_) async => false);
      when(mockRemoteDataSource.getModelosByMarca(marcaId, tipo, ano: null))
          .thenThrow(ServerException('Server error'));

      // Act
      final result = await repository.getModelosPorMarca(marcaId, tipo);

      // Assert
      expect(result, equals(Left(ServerFailure('Server error'))));
    });
  });

  group('getAnosCombustiveisPorModelo', () {
    const modeloId = 100;
    const tipo = TipoVeiculo.carro;

    test('deve buscar anos/combustíveis remotamente sempre', () async {
      // Arrange
      when(mockRemoteDataSource.getAnosCombustiveisByModelo(modeloId, tipo))
          .thenAnswer(
              (_) async => AnoCombustivelFixture.anosCombustiveisModelList);

      // Act
      final result =
          await repository.getAnosCombustiveisPorModelo(modeloId, tipo);

      // Assert
      expect(
        result,
        equals(Right(AnoCombustivelFixture.anosCombustiveisModelList)),
      );
      verify(mockRemoteDataSource.getAnosCombustiveisByModelo(modeloId, tipo));
      verifyNever(mockLocalDataSource.isCacheValid(any));
    });

    test('deve retornar NetworkFailure quando remoto lança NetworkException',
        () async {
      // Arrange
      when(mockRemoteDataSource.getAnosCombustiveisByModelo(modeloId, tipo))
          .thenThrow(NetworkException('No internet'));

      // Act
      final result =
          await repository.getAnosCombustiveisPorModelo(modeloId, tipo);

      // Assert
      expect(result, equals(Left(NetworkFailure('No internet'))));
    });
  });

  group('getAnosPorMarca', () {
    const marcaId = 1;
    const tipo = TipoVeiculo.carro;

    test('deve buscar anos por marca remotamente sempre', () async {
      // Arrange
      when(mockRemoteDataSource.getAnosPorMarca(marcaId, tipo)).thenAnswer(
          (_) async => AnoCombustivelFixture.anosCombustiveisModelList);

      // Act
      final result = await repository.getAnosPorMarca(marcaId, tipo);

      // Assert
      expect(
        result,
        equals(Right(AnoCombustivelFixture.anosCombustiveisModelList)),
      );
      verify(mockRemoteDataSource.getAnosPorMarca(marcaId, tipo));
    });

    test('deve retornar ServerFailure quando remoto lança ServerException',
        () async {
      // Arrange
      when(mockRemoteDataSource.getAnosPorMarca(marcaId, tipo))
          .thenThrow(ServerException('Database error'));

      // Act
      final result = await repository.getAnosPorMarca(marcaId, tipo);

      // Assert
      expect(result, equals(Left(ServerFailure('Database error'))));
    });
  });

  group('getValorFipe', () {
    const marcaId = 1;
    const modeloId = 100;
    const ano = '2024';
    const combustivel = 'Gasolina';
    const tipo = TipoVeiculo.carro;

    test('deve buscar valor FIPE remotamente e salvar em cache', () async {
      // Arrange
      when(mockRemoteDataSource.getValorFipe(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      )).thenAnswer((_) async => ValorFipeFixture.valorFipeModel);
      when(mockLocalDataSource.cacheValorFipe(any)).thenAnswer((_) async => {});

      // Act
      final result = await repository.getValorFipe(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      );

      // Assert
      expect(result, equals(Right(ValorFipeFixture.valorFipeModel)));
      verify(mockRemoteDataSource.getValorFipe(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      ));
      verify(mockLocalDataSource.cacheValorFipe(
        ValorFipeFixture.valorFipeModel,
      ));
    });

    test('deve retornar ServerFailure quando remoto lança ServerException',
        () async {
      // Arrange
      when(mockRemoteDataSource.getValorFipe(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      )).thenThrow(ServerException('API error'));

      // Act
      final result = await repository.getValorFipe(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      );

      // Assert
      expect(result, equals(Left(ServerFailure('API error'))));
    });

    test('deve retornar NetworkFailure quando remoto lança NetworkException',
        () async {
      // Arrange
      when(mockRemoteDataSource.getValorFipe(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      )).thenThrow(NetworkException('Connection timeout'));

      // Act
      final result = await repository.getValorFipe(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      );

      // Assert
      expect(result, equals(Left(NetworkFailure('Connection timeout'))));
    });

    test('deve retornar ServerFailure para erros genéricos', () async {
      // Arrange
      when(mockRemoteDataSource.getValorFipe(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      )).thenThrow(Exception('Unknown error'));

      // Act
      final result = await repository.getValorFipe(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      );

      // Assert
      expect(
        result,
        isA<Left>().having(
          (l) => l.value,
          'failure',
          isA<ServerFailure>().having(
              (f) => f.message, 'message', contains('Erro desconhecido')),
        ),
      );
    });
  });
}
