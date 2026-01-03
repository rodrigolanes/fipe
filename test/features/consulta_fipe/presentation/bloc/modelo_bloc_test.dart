import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:fipe/core/constants/app_constants.dart';
import 'package:fipe/core/error/failures.dart';
import 'package:fipe/features/consulta_fipe/domain/usecases/get_modelos_por_marca_usecase.dart';
import 'package:fipe/features/consulta_fipe/presentation/bloc/modelo_bloc.dart';
import 'package:fipe/features/consulta_fipe/presentation/bloc/modelo_event.dart';
import 'package:fipe/features/consulta_fipe/presentation/bloc/modelo_state.dart';

import '../../../../fixtures/modelo_fixture.dart';
import '../../../../helpers/mock_generator.mocks.dart';

void main() {
  late ModeloBloc bloc;
  late MockGetModelosPorMarcaUseCase mockGetModelosPorMarca;

  setUp(() {
    mockGetModelosPorMarca = MockGetModelosPorMarcaUseCase();
    bloc = ModeloBloc(getModelosPorMarca: mockGetModelosPorMarca);
  });

  tearDown(() {
    bloc.close();
  });

  test('estado inicial deve ser ModeloInitial', () {
    expect(bloc.state, equals(const ModeloInitial()));
  });

  group('LoadModelosPorMarcaEvent', () {
    const marcaId = 1;
    const tipo = TipoVeiculo.carro;

    blocTest<ModeloBloc, ModeloState>(
      'deve emitir [ModeloLoading, ModeloLoaded] quando busca for bem-sucedida',
      build: () {
        when(mockGetModelosPorMarca(any)).thenAnswer(
          (_) async => Right(ModeloFixture.modelosEntityList),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadModelosPorMarcaEvent(
        marcaId: marcaId,
        tipo: tipo,
      )),
      expect: () => [
        const ModeloLoading(),
        ModeloLoaded(
          modelos: ModeloFixture.modelosEntityList,
          filteredModelos: ModeloFixture.modelosEntityList,
        ),
      ],
      verify: (_) {
        verify(mockGetModelosPorMarca(GetModelosPorMarcaParams(
          marcaId: marcaId,
          tipo: tipo,
        ))).called(1);
      },
    );

    blocTest<ModeloBloc, ModeloState>(
      'deve emitir [ModeloLoading, ModeloLoaded] com filtro de ano',
      build: () {
        when(mockGetModelosPorMarca(any)).thenAnswer(
          (_) async => Right(ModeloFixture.modelosEntityList),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadModelosPorMarcaEvent(
        marcaId: marcaId,
        tipo: tipo,
        ano: '2024',
      )),
      expect: () => [
        const ModeloLoading(),
        ModeloLoaded(
          modelos: ModeloFixture.modelosEntityList,
          filteredModelos: ModeloFixture.modelosEntityList,
        ),
      ],
      verify: (_) {
        verify(mockGetModelosPorMarca(GetModelosPorMarcaParams(
          marcaId: marcaId,
          tipo: tipo,
          ano: '2024',
        ))).called(1);
      },
    );

    blocTest<ModeloBloc, ModeloState>(
      'deve emitir [ModeloLoading, ModeloError] quando ocorrer ServerFailure',
      build: () {
        when(mockGetModelosPorMarca(any)).thenAnswer(
          (_) async => Left(ServerFailure('Server error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadModelosPorMarcaEvent(
        marcaId: marcaId,
        tipo: tipo,
      )),
      expect: () => [
        const ModeloLoading(),
        const ModeloError('Erro ao buscar modelos no servidor'),
      ],
    );

    blocTest<ModeloBloc, ModeloState>(
      'deve emitir [ModeloLoading, ModeloError] quando ocorrer NetworkFailure',
      build: () {
        when(mockGetModelosPorMarca(any)).thenAnswer(
          (_) async => Left(NetworkFailure('No internet')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadModelosPorMarcaEvent(
        marcaId: marcaId,
        tipo: tipo,
      )),
      expect: () => [
        const ModeloLoading(),
        const ModeloError('Sem conexão com a internet'),
      ],
    );
  });

  group('SearchModelosEvent', () {
    blocTest<ModeloBloc, ModeloState>(
      'deve filtrar modelos com base na query',
      build: () => bloc,
      seed: () => ModeloLoaded(
        modelos: ModeloFixture.modelosEntityList,
        filteredModelos: ModeloFixture.modelosEntityList,
      ),
      act: (bloc) => bloc.add(const SearchModelosEvent('PALIO')),
      expect: () => [
        ModeloLoaded(
          modelos: ModeloFixture.modelosEntityList,
          filteredModelos: [ModeloFixture.modelosEntityList.first],
          searchQuery: 'PALIO',
        ),
      ],
    );

    blocTest<ModeloBloc, ModeloState>(
      'deve filtrar modelos case-insensitive',
      build: () => bloc,
      seed: () => ModeloLoaded(
        modelos: ModeloFixture.modelosEntityList,
        filteredModelos: ModeloFixture.modelosEntityList,
      ),
      act: (bloc) => bloc.add(const SearchModelosEvent('palio')),
      expect: () => [
        ModeloLoaded(
          modelos: ModeloFixture.modelosEntityList,
          filteredModelos: [ModeloFixture.modelosEntityList.first],
          searchQuery: 'palio',
        ),
      ],
    );

    blocTest<ModeloBloc, ModeloState>(
      'deve retornar todos os modelos quando query for vazia',
      build: () => bloc,
      seed: () => ModeloLoaded(
        modelos: ModeloFixture.modelosEntityList,
        filteredModelos: [ModeloFixture.modelosEntityList.first],
        searchQuery: 'PALIO',
      ),
      act: (bloc) => bloc.add(const SearchModelosEvent('')),
      expect: () => [
        ModeloLoaded(
          modelos: ModeloFixture.modelosEntityList,
          filteredModelos: ModeloFixture.modelosEntityList,
          searchQuery: '',
        ),
      ],
    );

    blocTest<ModeloBloc, ModeloState>(
      'não deve emitir nada se estado não for ModeloLoaded',
      build: () => bloc,
      seed: () => const ModeloInitial(),
      act: (bloc) => bloc.add(const SearchModelosEvent('PALIO')),
      expect: () => [],
    );
  });

  group('ClearSearchModelosEvent', () {
    blocTest<ModeloBloc, ModeloState>(
      'deve limpar a busca e mostrar todos os modelos',
      build: () => bloc,
      seed: () => ModeloLoaded(
        modelos: ModeloFixture.modelosEntityList,
        filteredModelos: [ModeloFixture.modelosEntityList.first],
        searchQuery: 'PALIO',
      ),
      act: (bloc) => bloc.add(const ClearSearchModelosEvent()),
      expect: () => [
        ModeloLoaded(
          modelos: ModeloFixture.modelosEntityList,
          filteredModelos: ModeloFixture.modelosEntityList,
          searchQuery: '',
        ),
      ],
    );

    blocTest<ModeloBloc, ModeloState>(
      'não deve emitir nada se estado não for ModeloLoaded',
      build: () => bloc,
      seed: () => const ModeloInitial(),
      act: (bloc) => bloc.add(const ClearSearchModelosEvent()),
      expect: () => [],
    );
  });
}
