import '../../../../core/constants/app_constants.dart';
import '../models/marca_model.dart';
import '../models/modelo_model.dart';
import '../models/valor_fipe_model.dart';

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

  /// Cache temporário de valor FIPE (TTL curto - 5 minutos)
  Future<void> cacheValorFipeTemp(
    ValorFipeModel valor,
    String mesReferencia,
  );

  /// Busca valor FIPE do cache temporário
  /// Retorna null se não encontrado ou expirado ou se mês for diferente
  Future<ValorFipeModel?> getValorFipeFromCache({
    required int marcaId,
    required int modeloId,
    required int anoModelo,
    required int codigoCombustivel,
    required int tipoVeiculo,
    required String mesReferencia,
  });
}
