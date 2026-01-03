import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:fipe/core/constants/app_constants.dart';
import 'package:fipe/core/error/failures.dart';
import 'package:fipe/features/consulta_fipe/domain/usecases/get_valor_fipe_usecase.dart';

import '../../../../fixtures/valor_fipe_fixture.dart';
import '../../../../helpers/mock_generator.mocks.dart';

void main() {
  late GetValorFipeUseCase usecase;
  late MockFipeRepository mockRepository;

  setUp(() {
    mockRepository = MockFipeRepository();
    usecase = GetValorFipeUseCase(mockRepository);
  });

  group('GetValorFipeUseCase', () {
    const tMarcaId = 1;
    const tModeloId = 100;
    const tAno = '2024';
    const tCombustivel = 'Gasolina';
    const tTipo = TipoVeiculo.carro;

    test('deve retornar ValorFipeEntity quando repository retornar sucesso',
        () async {
      // Arrange
      when(mockRepository.getValorFipe(
        marcaId: anyNamed('marcaId'),
        modeloId: anyNamed('modeloId'),
        ano: anyNamed('ano'),
        combustivel: anyNamed('combustivel'),
        tipo: anyNamed('tipo'),
      )).thenAnswer((_) async => Right(ValorFipeFixture.valorFipeEntity));

      // Act
      final result = await usecase(
        const GetValorFipeParams(
          marcaId: tMarcaId,
          modeloId: tModeloId,
          ano: tAno,
          combustivel: tCombustivel,
          tipo: tTipo,
        ),
      );

      // Assert
      expect(result, Right(ValorFipeFixture.valorFipeEntity));
      verify(mockRepository.getValorFipe(
        marcaId: tMarcaId,
        modeloId: tModeloId,
        ano: tAno,
        combustivel: tCombustivel,
        tipo: tTipo,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('deve retornar ServerFailure quando repository falhar', () async {
      // Arrange
      when(mockRepository.getValorFipe(
        marcaId: anyNamed('marcaId'),
        modeloId: anyNamed('modeloId'),
        ano: anyNamed('ano'),
        combustivel: anyNamed('combustivel'),
        tipo: anyNamed('tipo'),
      )).thenAnswer((_) async => Left(ServerFailure()));

      // Act
      final result = await usecase(
        const GetValorFipeParams(
          marcaId: tMarcaId,
          modeloId: tModeloId,
          ano: tAno,
          combustivel: tCombustivel,
          tipo: tTipo,
        ),
      );

      // Assert
      expect(result, Left(ServerFailure()));
    });

    test('deve retornar NetworkFailure quando houver erro de rede', () async {
      // Arrange
      when(mockRepository.getValorFipe(
        marcaId: anyNamed('marcaId'),
        modeloId: anyNamed('modeloId'),
        ano: anyNamed('ano'),
        combustivel: anyNamed('combustivel'),
        tipo: anyNamed('tipo'),
      )).thenAnswer((_) async => Left(NetworkFailure()));

      // Act
      final result = await usecase(
        const GetValorFipeParams(
          marcaId: tMarcaId,
          modeloId: tModeloId,
          ano: tAno,
          combustivel: tCombustivel,
          tipo: tTipo,
        ),
      );

      // Assert
      expect(result, Left(NetworkFailure()));
    });

    test('deve chamar repository com ano Zero KM correto', () async {
      // Arrange
      const tAnoZeroKm = '32000';
      when(mockRepository.getValorFipe(
        marcaId: anyNamed('marcaId'),
        modeloId: anyNamed('modeloId'),
        ano: anyNamed('ano'),
        combustivel: anyNamed('combustivel'),
        tipo: anyNamed('tipo'),
      )).thenAnswer((_) async => Right(ValorFipeFixture.valorFipeZeroKmEntity));

      // Act
      await usecase(
        const GetValorFipeParams(
          marcaId: tMarcaId,
          modeloId: tModeloId,
          ano: tAnoZeroKm,
          combustivel: tCombustivel,
          tipo: tTipo,
        ),
      );

      // Assert
      verify(mockRepository.getValorFipe(
        marcaId: tMarcaId,
        modeloId: tModeloId,
        ano: tAnoZeroKm,
        combustivel: tCombustivel,
        tipo: tTipo,
      ));
    });

    test('deve retornar NotFoundFailure quando veículo não existir', () async {
      // Arrange
      when(mockRepository.getValorFipe(
        marcaId: anyNamed('marcaId'),
        modeloId: anyNamed('modeloId'),
        ano: anyNamed('ano'),
        combustivel: anyNamed('combustivel'),
        tipo: anyNamed('tipo'),
      )).thenAnswer((_) async => Left(NotFoundFailure()));

      // Act
      final result = await usecase(
        const GetValorFipeParams(
          marcaId: tMarcaId,
          modeloId: tModeloId,
          ano: tAno,
          combustivel: tCombustivel,
          tipo: tTipo,
        ),
      );

      // Assert
      expect(result, Left(NotFoundFailure()));
    });
  });

  group('GetValorFipeParams', () {
    test('deve ser igual quando todos os parâmetros forem iguais', () {
      // Arrange
      const params1 = GetValorFipeParams(
        marcaId: 1,
        modeloId: 100,
        ano: '2024',
        combustivel: 'Gasolina',
        tipo: TipoVeiculo.carro,
      );
      const params2 = GetValorFipeParams(
        marcaId: 1,
        modeloId: 100,
        ano: '2024',
        combustivel: 'Gasolina',
        tipo: TipoVeiculo.carro,
      );

      // Assert
      expect(params1, equals(params2));
    });

    test('deve ser diferente quando marcaId for diferente', () {
      // Arrange
      const params1 = GetValorFipeParams(
        marcaId: 1,
        modeloId: 100,
        ano: '2024',
        combustivel: 'Gasolina',
        tipo: TipoVeiculo.carro,
      );
      const params2 = GetValorFipeParams(
        marcaId: 2,
        modeloId: 100,
        ano: '2024',
        combustivel: 'Gasolina',
        tipo: TipoVeiculo.carro,
      );

      // Assert
      expect(params1, isNot(equals(params2)));
    });

    test('deve ser diferente quando ano for diferente', () {
      // Arrange
      const params1 = GetValorFipeParams(
        marcaId: 1,
        modeloId: 100,
        ano: '2024',
        combustivel: 'Gasolina',
        tipo: TipoVeiculo.carro,
      );
      const params2 = GetValorFipeParams(
        marcaId: 1,
        modeloId: 100,
        ano: '2023',
        combustivel: 'Gasolina',
        tipo: TipoVeiculo.carro,
      );

      // Assert
      expect(params1, isNot(equals(params2)));
    });

    test('deve ser diferente quando combustível for diferente', () {
      // Arrange
      const params1 = GetValorFipeParams(
        marcaId: 1,
        modeloId: 100,
        ano: '2024',
        combustivel: 'Gasolina',
        tipo: TipoVeiculo.carro,
      );
      const params2 = GetValorFipeParams(
        marcaId: 1,
        modeloId: 100,
        ano: '2024',
        combustivel: 'Flex',
        tipo: TipoVeiculo.carro,
      );

      // Assert
      expect(params1, isNot(equals(params2)));
    });
  });
}
