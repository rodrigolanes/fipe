import 'package:hive/hive.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/marca_model.dart';
import '../models/modelo_model.dart';
import '../models/valor_fipe_model.dart';
import 'fipe_local_data_source.dart';

class FipeLocalDataSourceImpl implements FipeLocalDataSource {
  static const String marcasBoxName = 'marcas';
  static const String modelosBoxName = 'modelos';
  static const String valoresBoxName = 'valores';
  static const String cacheTimesBoxName = 'cache_times';

  @override
  Future<void> cacheMarcas(List<MarcaModel> marcas, TipoVeiculo tipo) async {
    try {
      final box = await Hive.openBox<MarcaModel>(marcasBoxName);
      await box.put(tipo.nome, marcas);

      // Salva timestamp do cache
      final timesBox = await Hive.openBox<int>(cacheTimesBoxName);
      await timesBox.put(
        'marcas_${tipo.nome}',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheException('Erro ao salvar marcas em cache: ${e.toString()}');
    }
  }

  @override
  Future<List<MarcaModel>> getCachedMarcas(TipoVeiculo tipo) async {
    try {
      final box = await Hive.openBox<MarcaModel>(marcasBoxName);
      final marcas = box.get(tipo.nome);

      if (marcas == null || marcas.isEmpty) {
        throw CacheException('Nenhuma marca encontrada no cache');
      }

      return marcas as List<MarcaModel>;
    } catch (e) {
      throw CacheException(
        'Erro ao recuperar marcas do cache: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> cacheModelos(List<ModeloModel> modelos, int marcaId) async {
    try {
      final box = await Hive.openBox<ModeloModel>(modelosBoxName);
      await box.put('marca_$marcaId', modelos);

      // Salva timestamp do cache
      final timesBox = await Hive.openBox<int>(cacheTimesBoxName);
      await timesBox.put(
        'modelos_$marcaId',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheException('Erro ao salvar modelos em cache: ${e.toString()}');
    }
  }

  @override
  Future<List<ModeloModel>> getCachedModelos(int marcaId) async {
    try {
      final box = await Hive.openBox<ModeloModel>(modelosBoxName);
      final modelos = box.get('marca_$marcaId');

      if (modelos == null || modelos.isEmpty) {
        throw CacheException('Nenhum modelo encontrado no cache');
      }

      return modelos as List<ModeloModel>;
    } catch (e) {
      throw CacheException(
        'Erro ao recuperar modelos do cache: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> cacheValorFipe(ValorFipeModel valor) async {
    try {
      final box = await Hive.openBox<ValorFipeModel>(valoresBoxName);
      await box.put(valor.codigoFipe, valor);

      // Salva timestamp do cache
      final timesBox = await Hive.openBox<int>(cacheTimesBoxName);
      await timesBox.put(
        'valor_${valor.codigoFipe}',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheException(
        'Erro ao salvar valor FIPE em cache: ${e.toString()}',
      );
    }
  }

  @override
  Future<ValorFipeModel?> getCachedValorFipe(String codigoFipe) async {
    try {
      final box = await Hive.openBox<ValorFipeModel>(valoresBoxName);
      return box.get(codigoFipe);
    } catch (e) {
      throw CacheException(
        'Erro ao recuperar valor FIPE do cache: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> isCacheValid(String key) async {
    try {
      final timesBox = await Hive.openBox<int>(cacheTimesBoxName);
      final timestamp = timesBox.get(key);

      if (timestamp == null) return false;

      final cacheDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheDate);

      // Cache válido por 1 hora (AppConstants.cacheTimeout)
      return difference.inSeconds < AppConstants.cacheTimeout;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await Hive.deleteBoxFromDisk(marcasBoxName);
      await Hive.deleteBoxFromDisk(modelosBoxName);
      await Hive.deleteBoxFromDisk(valoresBoxName);
      await Hive.deleteBoxFromDisk(cacheTimesBoxName);
    } catch (e) {
      throw CacheException('Erro ao limpar cache: ${e.toString()}');
    }
  }
}
