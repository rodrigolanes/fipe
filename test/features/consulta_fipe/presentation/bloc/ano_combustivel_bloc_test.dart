import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:fipe/core/constants/app_constants.dart';
import 'package:fipe/core/error/failures.dart';
import 'package:fipe/features/consulta_fipe/domain/usecases/get_anos_combustiveis_por_modelo_usecase.dart';
import 'package:fipe/features/consulta_fipe/domain/usecases/get_anos_por_marca_usecase.dart';
import 'package:fipe/features/consulta_fipe/presentation/bloc/ano_combustivel_bloc.dart';
import 'package:fipe/features/consulta_fipe/presentation/bloc/ano_combustivel_event.dart';
import 'package:fipe/features/consulta_fipe/presentation/bloc/ano_combustivel_state.dart';

import '../../../../fixtures/ano_combustivel_fixture.dart';
import '../../../../helpers/mock_generator.mocks.dart';

void main() {
  late AnoCombustivelBloc bloc;
  late MockGetAnosCombustiveisPorModeloUseCase mockGetAnosCombustiveisPorModelo;
  late MockGetAnosPorMarcaUseCase mockGetAnosPorMarca;

  setUp(() {
    mockGetAnosCombustiveisPorModelo =
        MockGetAnosCombustiveisPorModeloUseCase();
    mockGetAnosPorMarca = MockGetAnosPorMarcaUseCase();
    bloc = AnoCombustivelBloc(
      getAnosCombustiveisPorModelo: mockGetAnosCombustiveisPorModelo,
      getAnosPorMarca: mockGetAnosPorMarca,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('estado inicial deve ser AnoCombustivelInitial', () {
    expect(bloc.state, equals(const AnoCombustivelInitial()));
  });

  group('LoadAnosCombustiveisPorModeloEvent', () {
    const modeloId = 100;
    const tipo = TipoVeiculo.carro;

    blocTest<AnoCombustivelBloc, AnoCombustivelState>(
      'deve emitir [AnoCombustivelLoading, AnoCombustivelLoaded] quando busca for bem-sucedida',
      build: () {
        when(mockGetAnosCombustiveisPorModelo(any)).thenAnswer(
          (_) async => Right(AnoCombustivelFixture.anosCombustiveisEntityList),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadAnosCombustiveisPorModeloEvent(
        modeloId: modeloId,
        tipo: tipo,
      )),
      expect: () => [
        const AnoCombustivelLoading(),
        AnoCombustivelLoaded(
          AnoCombustivelFixture.anosCombustiveisEntityList,
        ),
      ],
      verify: (_) {
        verify(mockGetAnosCombustiveisPorModelo(
          GetAnosCombustiveisPorModeloParams(
            modeloId: modeloId,
            tipo: tipo,
          ),
        )).called(1);
      },
    );

    blocTest<AnoCombustivelBloc, AnoCombustivelState>(
      'deve emitir [AnoCombustivelLoading, AnoCombustivelError] quando ocorrer ServerFailure',
      build: () {
        when(mockGetAnosCombustiveisPorModelo(any)).thenAnswer(
          (_) async => Left(ServerFailure('Server error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadAnosCombustiveisPorModeloEvent(
        modeloId: modeloId,
        tipo: tipo,
      )),
      expect: () => [
        const AnoCombustivelLoading(),
        const AnoCombustivelError(
          'Erro ao buscar anos e combustíveis no servidor',
        ),
      ],
    );

    blocTest<AnoCombustivelBloc, AnoCombustivelState>(
      'deve emitir [AnoCombustivelLoading, AnoCombustivelError] quando ocorrer NetworkFailure',
      build: () {
        when(mockGetAnosCombustiveisPorModelo(any)).thenAnswer(
          (_) async => Left(NetworkFailure('No internet')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadAnosCombustiveisPorModeloEvent(
        modeloId: modeloId,
        tipo: tipo,
      )),
      expect: () => [
        const AnoCombustivelLoading(),
        const AnoCombustivelError('Sem conexão com a internet'),
      ],
    );
  });

  group('LoadAnosPorMarcaEvent', () {
    const marcaId = 1;
    const tipo = TipoVeiculo.carro;

    blocTest<AnoCombustivelBloc, AnoCombustivelState>(
      'deve emitir [AnoCombustivelLoading, AnoCombustivelLoaded] quando busca for bem-sucedida',
      build: () {
        when(mockGetAnosPorMarca(any)).thenAnswer(
          (_) async => Right(AnoCombustivelFixture.anosCombustiveisEntityList),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadAnosPorMarcaEvent(
        marcaId: marcaId,
        tipo: tipo,
      )),
      expect: () => [
        const AnoCombustivelLoading(),
        AnoCombustivelLoaded(
          AnoCombustivelFixture.anosCombustiveisEntityList,
        ),
      ],
      verify: (_) {
        verify(mockGetAnosPorMarca(
          GetAnosPorMarcaParams(marcaId: marcaId, tipo: tipo),
        )).called(1);
      },
    );

    blocTest<AnoCombustivelBloc, AnoCombustivelState>(
      'deve emitir [AnoCombustivelLoading, AnoCombustivelError] quando ocorrer ServerFailure',
      build: () {
        when(mockGetAnosPorMarca(any)).thenAnswer(
          (_) async => Left(ServerFailure('Server error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadAnosPorMarcaEvent(
        marcaId: marcaId,
        tipo: tipo,
      )),
      expect: () => [
        const AnoCombustivelLoading(),
        const AnoCombustivelError(
          'Erro ao buscar anos e combustíveis no servidor',
        ),
      ],
    );

    blocTest<AnoCombustivelBloc, AnoCombustivelState>(
      'deve emitir [AnoCombustivelLoading, AnoCombustivelError] quando ocorrer CacheFailure',
      build: () {
        when(mockGetAnosPorMarca(any)).thenAnswer(
          (_) async => Left(CacheFailure('Cache error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadAnosPorMarcaEvent(
        marcaId: marcaId,
        tipo: tipo,
      )),
      expect: () => [
        const AnoCombustivelLoading(),
        const AnoCombustivelError('Erro ao carregar dados do cache'),
      ],
    );
  });
}
