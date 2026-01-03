import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:fipe/core/constants/app_constants.dart';
import 'package:fipe/core/error/failures.dart';
import 'package:fipe/features/consulta_fipe/domain/usecases/get_anos_combustiveis_por_modelo_usecase.dart';

import '../../../../fixtures/ano_combustivel_fixture.dart';
import '../../../../helpers/mock_generator.mocks.dart';

void main() {
  late GetAnosCombustiveisPorModeloUseCase usecase;
  late MockFipeRepository mockRepository;

  setUp(() {
    mockRepository = MockFipeRepository();
    usecase = GetAnosCombustiveisPorModeloUseCase(mockRepository);
  });

  group('GetAnosCombustiveisPorModeloUseCase', () {
    const tModeloId = 100;
    const tTipo = TipoVeiculo.carro;

    test(
        'deve retornar lista de anos/combustíveis quando repository retornar sucesso',
        () async {
      // Arrange
      when(mockRepository.getAnosCombustiveisPorModelo(any, any)).thenAnswer(
        (_) async =>
            const Right(AnoCombustivelFixture.anosCombustiveisEntityList),
      );

      // Act
      final result = await usecase(
        const GetAnosCombustiveisPorModeloParams(
          modeloId: tModeloId,
          tipo: tTipo,
        ),
      );

      // Assert
      expect(
        result,
        const Right(AnoCombustivelFixture.anosCombustiveisEntityList),
      );
      verify(mockRepository.getAnosCombustiveisPorModelo(tModeloId, tTipo));
      verifyNoMoreInteractions(mockRepository);
    });

    test('deve retornar ServerFailure quando repository falhar', () async {
      // Arrange
      when(mockRepository.getAnosCombustiveisPorModelo(any, any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // Act
      final result = await usecase(
        const GetAnosCombustiveisPorModeloParams(
          modeloId: tModeloId,
          tipo: tTipo,
        ),
      );

      // Assert
      expect(result, Left(ServerFailure()));
      verify(mockRepository.getAnosCombustiveisPorModelo(tModeloId, tTipo));
    });

    test('deve retornar NetworkFailure quando houver erro de rede', () async {
      // Arrange
      when(mockRepository.getAnosCombustiveisPorModelo(any, any))
          .thenAnswer((_) async => Left(NetworkFailure()));

      // Act
      final result = await usecase(
        const GetAnosCombustiveisPorModeloParams(
          modeloId: tModeloId,
          tipo: tTipo,
        ),
      );

      // Assert
      expect(result, Left(NetworkFailure()));
    });

    test('deve chamar repository com parâmetros corretos para motos', () async {
      // Arrange
      when(mockRepository.getAnosCombustiveisPorModelo(any, any))
          .thenAnswer((_) async => const Right([]));

      // Act
      await usecase(
        const GetAnosCombustiveisPorModeloParams(
          modeloId: tModeloId,
          tipo: TipoVeiculo.moto,
        ),
      );

      // Assert
      verify(mockRepository.getAnosCombustiveisPorModelo(
          tModeloId, TipoVeiculo.moto));
    });
  });

  group('GetAnosCombustiveisPorModeloParams', () {
    test('deve ser igual quando modeloId e tipo forem iguais', () {
      // Arrange
      const params1 = GetAnosCombustiveisPorModeloParams(
        modeloId: 100,
        tipo: TipoVeiculo.carro,
      );
      const params2 = GetAnosCombustiveisPorModeloParams(
        modeloId: 100,
        tipo: TipoVeiculo.carro,
      );

      // Assert
      expect(params1, equals(params2));
    });

    test('deve ser diferente quando modeloId for diferente', () {
      // Arrange
      const params1 = GetAnosCombustiveisPorModeloParams(
        modeloId: 100,
        tipo: TipoVeiculo.carro,
      );
      const params2 = GetAnosCombustiveisPorModeloParams(
        modeloId: 101,
        tipo: TipoVeiculo.carro,
      );

      // Assert
      expect(params1, isNot(equals(params2)));
    });

    test('deve ser diferente quando tipo for diferente', () {
      // Arrange
      const params1 = GetAnosCombustiveisPorModeloParams(
        modeloId: 100,
        tipo: TipoVeiculo.carro,
      );
      const params2 = GetAnosCombustiveisPorModeloParams(
        modeloId: 100,
        tipo: TipoVeiculo.moto,
      );

      // Assert
      expect(params1, isNot(equals(params2)));
    });
  });
}
