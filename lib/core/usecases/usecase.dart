import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// Classe abstrata para casos de uso
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Classe para casos de uso sem parâmetros
class NoParams {
  const NoParams();
}
