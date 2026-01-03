import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:fipe/core/constants/app_constants.dart';
import 'package:fipe/core/error/failures.dart';
import 'package:fipe/features/consulta_fipe/domain/usecases/get_marcas_por_tipo_usecase.dart';

import '../../../../fixtures/marca_fixture.dart';
import '../../../../helpers/mock_generator.mocks.dart';

void main() {
  late GetMarcasPorTipoUseCase usecase;
  late MockFipeRepository mockRepository;

  setUp(() {
    mockRepository = MockFipeRepository();
    usecase = GetMarcasPorTipoUseCase(mockRepository);
  });

  group('GetMarcasPorTipoUseCase', () {
    test('deve retornar lista de marcas quando repository retornar sucesso',
        () async {
      // Arrange
      when(mockRepository.getMarcasPorTipo(any))
          .thenAnswer((_) async => const Right(MarcaFixture.marcasEntityList));

      // Act
      final result =
          await usecase(const GetMarcasPorTipoParams(tipo: TipoVeiculo.carro));

      // Assert
      expect(result, const Right(MarcaFixture.marcasEntityList));
      verify(mockRepository.getMarcasPorTipo(TipoVeiculo.carro));
      verifyNoMoreInteractions(mockRepository);
    });

    test('deve retornar ServerFailure quando repository falhar', () async {
      // Arrange
      when(mockRepository.getMarcasPorTipo(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // Act
      final result =
          await usecase(const GetMarcasPorTipoParams(tipo: TipoVeiculo.carro));

      // Assert
      expect(result, Left(ServerFailure()));
      verify(mockRepository.getMarcasPorTipo(TipoVeiculo.carro));
      verifyNoMoreInteractions(mockRepository);
    });

    test('deve retornar NetworkFailure quando houver erro de rede', () async {
      // Arrange
      when(mockRepository.getMarcasPorTipo(any))
          .thenAnswer((_) async => Left(NetworkFailure()));

      // Act
      final result =
          await usecase(const GetMarcasPorTipoParams(tipo: TipoVeiculo.carro));

      // Assert
      expect(result, Left(NetworkFailure()));
      verify(mockRepository.getMarcasPorTipo(TipoVeiculo.carro));
    });

    test('deve chamar repository com tipo correto para motos', () async {
      // Arrange
      when(mockRepository.getMarcasPorTipo(any))
          .thenAnswer((_) async => const Right([]));

      // Act
      await usecase(const GetMarcasPorTipoParams(tipo: TipoVeiculo.moto));

      // Assert
      verify(mockRepository.getMarcasPorTipo(TipoVeiculo.moto));
    });

    test('deve chamar repository com tipo correto para caminhões', () async {
      // Arrange
      when(mockRepository.getMarcasPorTipo(any))
          .thenAnswer((_) async => const Right([]));

      // Act
      await usecase(const GetMarcasPorTipoParams(tipo: TipoVeiculo.caminhao));

      // Assert
      verify(mockRepository.getMarcasPorTipo(TipoVeiculo.caminhao));
    });
  });

  group('GetMarcasPorTipoParams', () {
    test('deve ser Equatable - instâncias iguais devem ser iguais', () {
      // Arrange
      const params1 = GetMarcasPorTipoParams(tipo: TipoVeiculo.carro);
      const params2 = GetMarcasPorTipoParams(tipo: TipoVeiculo.carro);

      // Assert
      expect(params1, equals(params2));
    });

    test('deve ser Equatable - instâncias diferentes devem ser diferentes', () {
      // Arrange
      const params1 = GetMarcasPorTipoParams(tipo: TipoVeiculo.carro);
      const params2 = GetMarcasPorTipoParams(tipo: TipoVeiculo.moto);

      // Assert
      expect(params1, isNot(equals(params2)));
    });
  });
}
