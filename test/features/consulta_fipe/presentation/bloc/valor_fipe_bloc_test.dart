import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:fipe/core/constants/app_constants.dart';
import 'package:fipe/core/error/failures.dart';
import 'package:fipe/features/consulta_fipe/domain/usecases/get_valor_fipe_usecase.dart';
import 'package:fipe/features/consulta_fipe/presentation/bloc/valor_fipe_bloc.dart';
import 'package:fipe/features/consulta_fipe/presentation/bloc/valor_fipe_event.dart';
import 'package:fipe/features/consulta_fipe/presentation/bloc/valor_fipe_state.dart';

import '../../../../fixtures/valor_fipe_fixture.dart';
import '../../../../helpers/mock_generator.mocks.dart';

void main() {
  late ValorFipeBloc bloc;
  late MockGetValorFipeUseCase mockGetValorFipe;

  setUp(() {
    mockGetValorFipe = MockGetValorFipeUseCase();
    bloc = ValorFipeBloc(getValorFipe: mockGetValorFipe);
  });

  tearDown(() {
    bloc.close();
  });

  test('estado inicial deve ser ValorFipeInitial', () {
    expect(bloc.state, equals(const ValorFipeInitial()));
  });

  group('LoadValorFipeEvent', () {
    const marcaId = 1;
    const modeloId = 100;
    const ano = '2024';
    const combustivel = 'Gasolina';
    const tipo = TipoVeiculo.carro;

    blocTest<ValorFipeBloc, ValorFipeState>(
      'deve emitir [ValorFipeLoading, ValorFipeLoaded] quando busca for bem-sucedida',
      build: () {
        when(mockGetValorFipe(any)).thenAnswer(
          (_) async => Right(ValorFipeFixture.valorFipeEntity),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadValorFipeEvent(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      )),
      expect: () => [
        const ValorFipeLoading(),
        ValorFipeLoaded(ValorFipeFixture.valorFipeEntity),
      ],
      verify: (_) {
        verify(mockGetValorFipe(GetValorFipeParams(
          marcaId: marcaId,
          modeloId: modeloId,
          ano: ano,
          combustivel: combustivel,
          tipo: tipo,
        ))).called(1);
      },
    );

    blocTest<ValorFipeBloc, ValorFipeState>(
      'deve emitir [ValorFipeLoading, ValorFipeError] quando ocorrer ServerFailure',
      build: () {
        when(mockGetValorFipe(any)).thenAnswer(
          (_) async => Left(ServerFailure('Server error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadValorFipeEvent(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      )),
      expect: () => [
        const ValorFipeLoading(),
        const ValorFipeError('Erro ao buscar valor FIPE no servidor'),
      ],
    );

    blocTest<ValorFipeBloc, ValorFipeState>(
      'deve emitir [ValorFipeLoading, ValorFipeError] quando ocorrer NetworkFailure',
      build: () {
        when(mockGetValorFipe(any)).thenAnswer(
          (_) async => Left(NetworkFailure('No internet')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadValorFipeEvent(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      )),
      expect: () => [
        const ValorFipeLoading(),
        const ValorFipeError('Sem conexão com a internet'),
      ],
    );

    blocTest<ValorFipeBloc, ValorFipeState>(
      'deve emitir [ValorFipeLoading, ValorFipeError] quando ocorrer NotFoundFailure',
      build: () {
        when(mockGetValorFipe(any)).thenAnswer(
          (_) async => Left(NotFoundFailure('Not found')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadValorFipeEvent(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      )),
      expect: () => [
        const ValorFipeLoading(),
        const ValorFipeError('Valor FIPE não encontrado'),
      ],
    );

    blocTest<ValorFipeBloc, ValorFipeState>(
      'deve emitir [ValorFipeLoading, ValorFipeError] quando ocorrer CacheFailure',
      build: () {
        when(mockGetValorFipe(any)).thenAnswer(
          (_) async => Left(CacheFailure('Cache error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadValorFipeEvent(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: ano,
        combustivel: combustivel,
        tipo: tipo,
      )),
      expect: () => [
        const ValorFipeLoading(),
        const ValorFipeError('Erro ao carregar dados do cache'),
      ],
    );

    blocTest<ValorFipeBloc, ValorFipeState>(
      'deve funcionar com veículo Zero KM',
      build: () {
        when(mockGetValorFipe(any)).thenAnswer(
          (_) async => Right(ValorFipeFixture.valorFipeZeroKmEntity),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadValorFipeEvent(
        marcaId: marcaId,
        modeloId: modeloId,
        ano: '32000',
        combustivel: 'Flex',
        tipo: tipo,
      )),
      expect: () => [
        const ValorFipeLoading(),
        ValorFipeLoaded(ValorFipeFixture.valorFipeZeroKmEntity),
      ],
    );
  });
}
