/// Exceção de servidor
class ServerException implements Exception {
  final String message;

  ServerException([this.message = 'Erro no servidor']);

  @override
  String toString() => 'ServerException: $message';
}

/// Exceção de cache
class CacheException implements Exception {
  final String message;

  CacheException([this.message = 'Erro no cache']);

  @override
  String toString() => 'CacheException: $message';
}

/// Exceção de rede
class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = 'Erro de rede']);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exceção de validação
class ValidationException implements Exception {
  final String message;

  ValidationException([this.message = 'Erro de validação']);

  @override
  String toString() => 'ValidationException: $message';
}

/// Exceção de não encontrado
class NotFoundException implements Exception {
  final String message;

  NotFoundException([this.message = 'Não encontrado']);

  @override
  String toString() => 'NotFoundException: $message';
}
