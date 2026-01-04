import '../../../../core/constants/app_constants.dart';
import '../models/marca_model.dart';
import '../models/modelo_model.dart';

/// Interface para a fonte de dados local (SQLite)
abstract class FipeLocalDataSource {
  /// Salva marcas em cache
  Future<void> cacheMarcas(List<MarcaModel> marcas, TipoVeiculo tipo);

  /// Recupera marcas do cache
  Future<List<MarcaModel>> getCachedMarcas(TipoVeiculo tipo);

  /// Salva modelos em cache
  Future<void> cacheModelos(List<ModeloModel> modelos, int marcaId);

  /// Recupera modelos do cache
  Future<List<ModeloModel>> getCachedModelos(int marcaId);

  /// Verifica se o cache está válido
  Future<bool> isCacheValid(String key);

  /// Limpa todo o cache
  Future<void> clearCache();
}
