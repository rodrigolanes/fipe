import 'package:equatable/equatable.dart';

/// Classe abstrata para falhas na aplicação
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Falha de servidor (erro na API/Supabase)
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Erro ao conectar com o servidor']);
}

/// Falha de cache (erro ao salvar/recuperar cache local)
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Erro ao acessar cache local']);
}

/// Falha de rede (sem conexão com internet)
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Sem conexão com a internet']);
}

/// Falha de validação (dados inválidos)
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Dados inválidos']);
}

/// Falha não encontrada (recurso não existe)
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Recurso não encontrado']);
}
