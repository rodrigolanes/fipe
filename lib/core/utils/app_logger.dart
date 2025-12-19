import 'package:logger/logger.dart';

/// Classe singleton para gerenciar logging na aplicação
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  late final Logger _logger;

  factory AppLogger() {
    return _instance;
  }

  AppLogger._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2, // número de chamadas de método a serem exibidas
        errorMethodCount: 8, // número de chamadas de método em caso de erro
        lineLength: 120, // largura da saída
        colors: true, // cores no console
        printEmojis: true, // emojis no console
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: Level.debug, // nível de log padrão
    );
  }

  /// Logger para produção (sem cores e emojis)
  static Logger get production => Logger(
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 5,
          lineLength: 120,
          colors: false,
          printEmojis: false,
          dateTimeFormat: DateTimeFormat.onlyTime,
        ),
        level: Level.warning, // apenas warnings e errors em produção
      );

  /// Log de debug (verbose)
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log de informação
  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log de warning
  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log de erro
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal (very serious)
  static void f(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Log de trace (muito verbose)
  static void t(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger.t(message, error: error, stackTrace: stackTrace);
  }
}