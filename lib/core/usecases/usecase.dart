import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// Classe abstrata para casos de uso
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Classe para casos de uso sem parâmetros
class NoParams {
  const NoParams();
}
