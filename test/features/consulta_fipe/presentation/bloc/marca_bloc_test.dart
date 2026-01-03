import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:fipe/core/constants/app_constants.dart';
import 'package:fipe/core/error/failures.dart';
import 'package:fipe/features/consulta_fipe/domain/usecases/get_marcas_por_tipo_usecase.dart';
import 'package:fipe/features/consulta_fipe/presentation/bloc/marca_bloc.dart';
import 'package:fipe/features/consulta_fipe/presentation/bloc/marca_event.dart';
import 'package:fipe/features/consulta_fipe/presentation/bloc/marca_state.dart';

import '../../../../fixtures/marca_fixture.dart';
import '../../../../helpers/mock_generator.mocks.dart';

void main() {
  late MarcaBloc bloc;
  late MockGetMarcasPorTipoUseCase mockGetMarcasPorTipo;

  setUp(() {
    mockGetMarcasPorTipo = MockGetMarcasPorTipoUseCase();
    bloc = MarcaBloc(getMarcasPorTipo: mockGetMarcasPorTipo);
  });

  tearDown(() {
    bloc.close();
  });

  test('estado inicial deve ser MarcaInitial', () {
    expect(bloc.state, equals(const MarcaInitial()));
  });

  group('LoadMarcasPorTipoEvent', () {
    const tipo = TipoVeiculo.carro;

    blocTest<MarcaBloc, MarcaState>(
      'deve emitir [MarcaLoading, MarcaLoaded] quando busca for bem-sucedida',
      build: () {
        when(mockGetMarcasPorTipo(any)).thenAnswer(
          (_) async => Right(MarcaFixture.marcasEntityList),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadMarcasPorTipoEvent(tipo)),
      expect: () => [
        const MarcaLoading(),
        MarcaLoaded(
          marcas: MarcaFixture.marcasEntityList,
          filteredMarcas: MarcaFixture.marcasEntityList,
        ),
      ],
      verify: (_) {
        verify(mockGetMarcasPorTipo(GetMarcasPorTipoParams(tipo: tipo)))
            .called(1);
      },
    );

    blocTest<MarcaBloc, MarcaState>(
      'deve emitir [MarcaLoading, MarcaError] quando ocorrer ServerFailure',
      build: () {
        when(mockGetMarcasPorTipo(any)).thenAnswer(
          (_) async => Left(ServerFailure('Server error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadMarcasPorTipoEvent(tipo)),
      expect: () => [
        const MarcaLoading(),
        const MarcaError('Erro ao buscar marcas no servidor'),
      ],
    );

    blocTest<MarcaBloc, MarcaState>(
      'deve emitir [MarcaLoading, MarcaError] quando ocorrer NetworkFailure',
      build: () {
        when(mockGetMarcasPorTipo(any)).thenAnswer(
          (_) async => Left(NetworkFailure('No internet')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadMarcasPorTipoEvent(tipo)),
      expect: () => [
        const MarcaLoading(),
        const MarcaError('Sem conexão com a internet'),
      ],
    );

    blocTest<MarcaBloc, MarcaState>(
      'deve emitir [MarcaLoading, MarcaError] quando ocorrer CacheFailure',
      build: () {
        when(mockGetMarcasPorTipo(any)).thenAnswer(
          (_) async => Left(CacheFailure('Cache error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadMarcasPorTipoEvent(tipo)),
      expect: () => [
        const MarcaLoading(),
        const MarcaError('Erro ao carregar dados do cache'),
      ],
    );
  });

  group('SearchMarcasEvent', () {
    blocTest<MarcaBloc, MarcaState>(
      'deve filtrar marcas com base na query',
      build: () => bloc,
      seed: () => MarcaLoaded(
        marcas: MarcaFixture.marcasEntityList,
        filteredMarcas: MarcaFixture.marcasEntityList,
      ),
      act: (bloc) => bloc.add(const SearchMarcasEvent('FIAT')),
      expect: () => [
        MarcaLoaded(
          marcas: MarcaFixture.marcasEntityList,
          filteredMarcas: [MarcaFixture.marcasEntityList.first],
          searchQuery: 'FIAT',
        ),
      ],
    );

    blocTest<MarcaBloc, MarcaState>(
      'deve filtrar marcas case-insensitive',
      build: () => bloc,
      seed: () => MarcaLoaded(
        marcas: MarcaFixture.marcasEntityList,
        filteredMarcas: MarcaFixture.marcasEntityList,
      ),
      act: (bloc) => bloc.add(const SearchMarcasEvent('fiat')),
      expect: () => [
        MarcaLoaded(
          marcas: MarcaFixture.marcasEntityList,
          filteredMarcas: [MarcaFixture.marcasEntityList.first],
          searchQuery: 'fiat',
        ),
      ],
    );

    blocTest<MarcaBloc, MarcaState>(
      'deve retornar todas as marcas quando query for vazia',
      build: () => bloc,
      seed: () => MarcaLoaded(
        marcas: MarcaFixture.marcasEntityList,
        filteredMarcas: [MarcaFixture.marcasEntityList.first],
        searchQuery: 'FIAT',
      ),
      act: (bloc) => bloc.add(const SearchMarcasEvent('')),
      expect: () => [
        MarcaLoaded(
          marcas: MarcaFixture.marcasEntityList,
          filteredMarcas: MarcaFixture.marcasEntityList,
          searchQuery: '',
        ),
      ],
    );

    blocTest<MarcaBloc, MarcaState>(
      'não deve emitir nada se estado não for MarcaLoaded',
      build: () => bloc,
      seed: () => const MarcaInitial(),
      act: (bloc) => bloc.add(const SearchMarcasEvent('FIAT')),
      expect: () => [],
    );
  });

  group('ClearSearchMarcasEvent', () {
    blocTest<MarcaBloc, MarcaState>(
      'deve limpar a busca e mostrar todas as marcas',
      build: () => bloc,
      seed: () => MarcaLoaded(
        marcas: MarcaFixture.marcasEntityList,
        filteredMarcas: [MarcaFixture.marcasEntityList.first],
        searchQuery: 'FIAT',
      ),
      act: (bloc) => bloc.add(const ClearSearchMarcasEvent()),
      expect: () => [
        MarcaLoaded(
          marcas: MarcaFixture.marcasEntityList,
          filteredMarcas: MarcaFixture.marcasEntityList,
          searchQuery: '',
        ),
      ],
    );

    blocTest<MarcaBloc, MarcaState>(
      'não deve emitir nada se estado não for MarcaLoaded',
      build: () => bloc,
      seed: () => const MarcaInitial(),
      act: (bloc) => bloc.add(const ClearSearchMarcasEvent()),
      expect: () => [],
    );
  });
}
