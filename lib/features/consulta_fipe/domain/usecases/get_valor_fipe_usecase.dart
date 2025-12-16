import 'package:dartz/dartz.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/valor_fipe_entity.dart';
import '../repositories/fipe_repository.dart';

/// UseCase para buscar o valor FIPE de um veículo específico
///
/// Este caso de uso é responsável por recuperar o valor FIPE de um veículo
/// específico com base em suas características (marca, modelo, ano, combustível).
///
/// Exemplo de uso:
/// ```dart
/// final result = await getValorFipeUseCase(GetValorFipeParams(
///   marcaId: 1,
///   modeloId: 123,
///   ano: '2023-1',
///   combustivel: 'Gasolina',
///   tipo: TipoVeiculo.carro,
/// ));
/// result.fold(
///   (failure) => print('Erro: $failure'),
///   (valorFipe) => print('Valor: ${valorFipe.valor}'),
/// );
/// ```
class GetValorFipeUseCase
    implements UseCase<ValorFipeEntity, GetValorFipeParams> {
  final FipeRepository repository;

  const GetValorFipeUseCase(this.repository);

  @override
  Future<Either<Failure, ValorFipeEntity>> call(
    GetValorFipeParams params,
  ) async {
    return await repository.getValorFipe(
      marcaId: params.marcaId,
      modeloId: params.modeloId,
      ano: params.ano,
      combustivel: params.combustivel,
      tipo: params.tipo,
    );
  }
}

/// Parâmetros para o GetValorFipeUseCase
class GetValorFipeParams {
  final int marcaId;
  final int modeloId;
  final String ano;
  final String combustivel;
  final TipoVeiculo tipo;

  const GetValorFipeParams({
    required this.marcaId,
    required this.modeloId,
    required this.ano,
    required this.combustivel,
    required this.tipo,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetValorFipeParams &&
        other.marcaId == marcaId &&
        other.modeloId == modeloId &&
        other.ano == ano &&
        other.combustivel == combustivel &&
        other.tipo == tipo;
  }

  @override
  int get hashCode {
    return marcaId.hashCode ^
        modeloId.hashCode ^
        ano.hashCode ^
        combustivel.hashCode ^
        tipo.hashCode;
  }
}
