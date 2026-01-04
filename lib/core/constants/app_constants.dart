/// Constantes globais da aplicação
class AppConstants {
  AppConstants._();

  /// Nome da aplicação
  static const String appName = 'FIPE Consulta';

  /// Versão da aplicação
  static const String appVersion = '1.0.0';

  /// Timeout de cache em segundos (1 hora) - para marcas e modelos
  static const int cacheTimeout = 3600;

  /// Timeout de cache de valores FIPE em segundos (5 minutos)
  /// Cache curto para garantir valores atualizados mas reduzir requisições
  static const int valorFipeCacheTimeout = 300;

  /// Limite de paginação
  static const int paginationLimit = 50;

  /// Tempo de debounce para busca em milissegundos
  static const int searchDebounceTime = 300;

  /// Número máximo de favoritos
  static const int maxFavorites = 50;

  /// Delay para splash screen em milissegundos
  static const int splashDelay = 2000;
}

/// Tipos de veículos disponíveis na FIPE
enum TipoVeiculo {
  carro('carros', 1),
  moto('motos', 2),
  caminhao('caminhoes', 3);

  const TipoVeiculo(this.nome, this.codigo);

  final String nome;
  final int codigo;
}

/// Status de carregamento genérico
enum LoadingStatus { initial, loading, success, error }
