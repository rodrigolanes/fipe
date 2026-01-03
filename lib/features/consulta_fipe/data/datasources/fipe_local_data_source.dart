import '../../../../core/constants/app_constants.dart';
import '../models/marca_model.dart';
import '../models/mes_referencia_model.dart';
import '../models/modelo_model.dart';
import '../models/valor_fipe_model.dart';

/// Interface para a fonte de dados local (Hive)
abstract class FipeLocalDataSource {
  /// Salva marcas em cache
  Future<void> cacheMarcas(List<MarcaModel> marcas, TipoVeiculo tipo);

  /// Recupera marcas do cache
  Future<List<MarcaModel>> getCachedMarcas(TipoVeiculo tipo);

  /// Salva modelos em cache
  Future<void> cacheModelos(List<ModeloModel> modelos, int marcaId);

  /// Recupera modelos do cache
  Future<List<ModeloModel>> getCachedModelos(int marcaId);

  /// Salva valor FIPE em cache com chave customizada
  Future<void> cacheValorFipe(ValorFipeModel valor, String cacheKey);

  /// Recupera valor FIPE do cache pela chave customizada
  Future<ValorFipeModel?> getCachedValorFipe(String cacheKey);

  /// Verifica se o cache está válido
  Future<bool> isCacheValid(String key);

  /// Limpa todo o cache
  Future<void> clearCache();

  /// Salva o mês de referência atual
  Future<void> saveMesReferencia(MesReferenciaModel mesReferencia);

  /// Recupera o mês de referência armazenado localmente
  Future<MesReferenciaModel?> getLocalMesReferencia();

  /// Salva todas as marcas de uma vez (sincronização completa)
  Future<void> saveAllMarcas(List<MarcaModel> marcas);

  /// Salva todos os modelos de uma marca (sincronização completa)
  Future<void> saveAllModelos(List<ModeloModel> modelos, int marcaId);
}
