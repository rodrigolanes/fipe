import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:fipe/core/constants/app_constants.dart';
import 'package:fipe/core/error/failures.dart';
import 'package:fipe/features/consulta_fipe/domain/usecases/get_anos_por_marca_usecase.dart';

import '../../../../fixtures/ano_combustivel_fixture.dart';
import '../../../../helpers/mock_generator.mocks.dart';

void main() {
  late GetAnosPorMarcaUseCase usecase;
  late MockFipeRepository mockRepository;

  setUp(() {
    mockRepository = MockFipeRepository();
    usecase = GetAnosPorMarcaUseCase(mockRepository);
  });

  group('GetAnosPorMarcaUseCase', () {
    const tMarcaId = 1;
    const tTipo = TipoVeiculo.carro;

    test('deve retornar lista de anos quando repository retornar sucesso',
        () async {
      // Arrange
      when(mockRepository.getAnosPorMarca(any, any)).thenAnswer(
        (_) async =>
            const Right(AnoCombustivelFixture.anosCombustiveisEntityList),
      );

      // Act
      final result = await usecase(
        const GetAnosPorMarcaParams(marcaId: tMarcaId, tipo: tTipo),
      );

      // Assert
      expect(
        result,
        const Right(AnoCombustivelFixture.anosCombustiveisEntityList),
      );
      verify(mockRepository.getAnosPorMarca(tMarcaId, tTipo));
      verifyNoMoreInteractions(mockRepository);
    });

    test('deve retornar ServerFailure quando repository falhar', () async {
      // Arrange
      when(mockRepository.getAnosPorMarca(any, any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // Act
      final result = await usecase(
        const GetAnosPorMarcaParams(marcaId: tMarcaId, tipo: tTipo),
      );

      // Assert
      expect(result, Left(ServerFailure()));
      verify(mockRepository.getAnosPorMarca(tMarcaId, tTipo));
    });

    test('deve retornar NetworkFailure quando houver erro de rede', () async {
      // Arrange
      when(mockRepository.getAnosPorMarca(any, any))
          .thenAnswer((_) async => Left(NetworkFailure()));

      // Act
      final result = await usecase(
        const GetAnosPorMarcaParams(marcaId: tMarcaId, tipo: tTipo),
      );

      // Assert
      expect(result, Left(NetworkFailure()));
    });

    test('deve chamar repository com parâmetros corretos para caminhões',
        () async {
      // Arrange
      when(mockRepository.getAnosPorMarca(any, any))
          .thenAnswer((_) async => const Right([]));

      // Act
      await usecase(
        const GetAnosPorMarcaParams(
          marcaId: tMarcaId,
          tipo: TipoVeiculo.caminhao,
        ),
      );

      // Assert
      verify(mockRepository.getAnosPorMarca(tMarcaId, TipoVeiculo.caminhao));
    });
  });

  group('GetAnosPorMarcaParams', () {
    test('deve implementar Equatable corretamente', () {
      // Arrange
      const params1 = GetAnosPorMarcaParams(
        marcaId: 1,
        tipo: TipoVeiculo.carro,
      );
      const params2 = GetAnosPorMarcaParams(
        marcaId: 1,
        tipo: TipoVeiculo.carro,
      );

      // Assert
      expect(params1, equals(params2));
      expect(params1.props, [1, TipoVeiculo.carro]);
    });

    test('deve ser diferente quando marcaId for diferente', () {
      // Arrange
      const params1 = GetAnosPorMarcaParams(
        marcaId: 1,
        tipo: TipoVeiculo.carro,
      );
      const params2 = GetAnosPorMarcaParams(
        marcaId: 2,
        tipo: TipoVeiculo.carro,
      );

      // Assert
      expect(params1, isNot(equals(params2)));
    });

    test('deve ser diferente quando tipo for diferente', () {
      // Arrange
      const params1 = GetAnosPorMarcaParams(
        marcaId: 1,
        tipo: TipoVeiculo.carro,
      );
      const params2 = GetAnosPorMarcaParams(
        marcaId: 1,
        tipo: TipoVeiculo.moto,
      );

      // Assert
      expect(params1, isNot(equals(params2)));
    });
  });
}
