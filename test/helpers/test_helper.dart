import 'package:flutter_test/flutter_test.dart';

/// Helper para configuração de testes
class TestHelper {
  /// Inicializa configurações necessárias para testes
  static Future<void> init() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  }

  /// Limpeza após testes (se necessário)
  static Future<void> cleanup() async {
    // Adicionar limpezas futuras aqui se necessário
  }
}
