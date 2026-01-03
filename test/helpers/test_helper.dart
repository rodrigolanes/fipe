import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:fipe/features/consulta_fipe/data/models/ano_combustivel_model.dart';
import 'package:fipe/features/consulta_fipe/data/models/marca_model.dart';
import 'package:fipe/features/consulta_fipe/data/models/modelo_model.dart';
import 'package:fipe/features/consulta_fipe/data/models/valor_fipe_model.dart';

/// Helper para configuração de testes
class TestHelper {
  /// Registra todos os adapters do Hive necessários para os testes
  static void registerHiveAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MarcaModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ModeloModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(AnoCombustivelModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(ValorFipeModelAdapter());
    }
  }

  /// Inicializa Hive para testes
  static Future<void> initHive() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init(null);
    registerHiveAdapters();
  }

  /// Limpa todos os boxes do Hive após os testes
  static Future<void> clearHive() async {
    await Hive.close();
  }
}
