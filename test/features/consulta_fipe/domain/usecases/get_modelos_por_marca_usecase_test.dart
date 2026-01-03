import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:fipe/core/constants/app_constants.dart';
import 'package:fipe/core/error/failures.dart';
import 'package:fipe/features/consulta_fipe/domain/usecases/get_modelos_por_marca_usecase.dart';

import '../../../../fixtures/modelo_fixture.dart';
import '../../../../helpers/mock_generator.mocks.dart';

void main() {
  late GetModelosPorMarcaUseCase usecase;
  late MockFipeRepository mockRepository;

  setUp(() {
    mockRepository = MockFipeRepository();
    usecase = GetModelosPorMarcaUseCase(mockRepository);
  });

  group('GetModelosPorMarcaUseCase', () {
    const tMarcaId = 1;
    const tTipo = TipoVeiculo.carro;

    test('deve retornar lista de modelos quando repository retornar sucesso',
        () async {
      // Arrange
      when(mockRepository.getModelosPorMarca(any, any, ano: anyNamed('ano')))
          .thenAnswer(
              (_) async => const Right(ModeloFixture.modelosEntityList));

      // Act
      final result = await usecase(const GetModelosPorMarcaParams(
        marcaId: tMarcaId,
        tipo: tTipo,
      ));

      // Assert
      expect(result, const Right(ModeloFixture.modelosEntityList));
      verify(mockRepository.getModelosPorMarca(tMarcaId, tTipo, ano: null));
      verifyNoMoreInteractions(mockRepository);
    });

    test('deve retornar modelos filtrados por ano quando ano for fornecido',
        () async {
      // Arrange
      const tAno = '2024';
      when(mockRepository.getModelosPorMarca(any, any, ano: anyNamed('ano')))
          .thenAnswer(
              (_) async => const Right(ModeloFixture.modelosEntityList));

      // Act
      final result = await usecase(const GetModelosPorMarcaParams(
        marcaId: tMarcaId,
        tipo: tTipo,
        ano: tAno,
      ));

      // Assert
      expect(result, const Right(ModeloFixture.modelosEntityList));
      verify(mockRepository.getModelosPorMarca(tMarcaId, tTipo, ano: tAno));
    });

    test('deve retornar ServerFailure quando repository falhar', () async {
      // Arrange
      when(mockRepository.getModelosPorMarca(any, any, ano: anyNamed('ano')))
          .thenAnswer((_) async => Left(ServerFailure()));

      // Act
      final result = await usecase(const GetModelosPorMarcaParams(
        marcaId: tMarcaId,
        tipo: tTipo,
      ));

      // Assert
      expect(result, Left(ServerFailure()));
      verify(mockRepository.getModelosPorMarca(tMarcaId, tTipo, ano: null));
    });

    test('deve retornar NetworkFailure quando houver erro de rede', () async {
      // Arrange
      when(mockRepository.getModelosPorMarca(any, any, ano: anyNamed('ano')))
          .thenAnswer((_) async => Left(NetworkFailure()));

      // Act
      final result = await usecase(const GetModelosPorMarcaParams(
        marcaId: tMarcaId,
        tipo: tTipo,
      ));

      // Assert
      expect(result, Left(NetworkFailure()));
    });
  });

  group('GetModelosPorMarcaParams', () {
    test('deve ser Equatable - instâncias iguais devem ser iguais', () {
      // Arrange
      const params1 = GetModelosPorMarcaParams(
        marcaId: 1,
        tipo: TipoVeiculo.carro,
      );
      const params2 = GetModelosPorMarcaParams(
        marcaId: 1,
        tipo: TipoVeiculo.carro,
      );

      // Assert
      expect(params1, equals(params2));
    });

    test('deve ser Equatable - instâncias diferentes devem ser diferentes', () {
      // Arrange
      const params1 = GetModelosPorMarcaParams(
        marcaId: 1,
        tipo: TipoVeiculo.carro,
      );
      const params2 = GetModelosPorMarcaParams(
        marcaId: 2,
        tipo: TipoVeiculo.carro,
      );

      // Assert
      expect(params1, isNot(equals(params2)));
    });
  });
}
