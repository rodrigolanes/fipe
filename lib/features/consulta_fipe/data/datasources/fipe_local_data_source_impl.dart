import 'package:hive/hive.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/marca_model.dart';
import '../models/mes_referencia_model.dart';
import '../models/modelo_model.dart';
import '../models/sync_version_model.dart';
import '../models/valor_fipe_model.dart';
import 'fipe_local_data_source.dart';

class FipeLocalDataSourceImpl implements FipeLocalDataSource {
  static const String marcasBoxName = 'marcas';
  static const String modelosBoxName = 'modelos';
  static const String valoresBoxName = 'valores';
  static const String cacheTimesBoxName = 'cache_times';
  static const String mesReferenciaBoxName = 'mes_referencia';
  static const String mesReferenciaKey = 'current_mes_referencia';
  static const String syncVersionBoxName = 'sync_version';
  static const String syncVersionKey = 'current_sync_version';

  @override
  Future<void> cacheMarcas(List<MarcaModel> marcas, TipoVeiculo tipo) async {
    try {
      final box = await Hive.openBox<List<dynamic>>(marcasBoxName);
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
      final box = await Hive.openBox<List<dynamic>>(marcasBoxName);
      final marcas = box.get(tipo.nome);

      if (marcas == null || marcas.isEmpty) {
        throw CacheException('Nenhuma marca encontrada no cache');
      }

      return marcas.cast<MarcaModel>();
    } catch (e) {
      throw CacheException(
        'Erro ao recuperar marcas do cache: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> cacheModelos(List<ModeloModel> modelos, int marcaId) async {
    try {
      final box = await Hive.openBox<List<dynamic>>(modelosBoxName);
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
      final box = await Hive.openBox<List<dynamic>>(modelosBoxName);
      final modelos = box.get('marca_$marcaId');

      if (modelos == null || modelos.isEmpty) {
        throw CacheException('Nenhum modelo encontrado no cache');
      }

      return modelos.cast<ModeloModel>();
    } catch (e) {
      throw CacheException(
        'Erro ao recuperar modelos do cache: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> cacheValorFipe(ValorFipeModel valor, String cacheKey) async {
    try {
      final box = await Hive.openBox<ValorFipeModel>(valoresBoxName);
      await box.put(cacheKey, valor);

      // Salva timestamp do cache
      final timesBox = await Hive.openBox<int>(cacheTimesBoxName);
      await timesBox.put(
        'valor_$cacheKey',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheException(
        'Erro ao salvar valor FIPE em cache: ${e.toString()}',
      );
    }
  }

  @override
  Future<ValorFipeModel?> getCachedValorFipe(String cacheKey) async {
    try {
      final box = await Hive.openBox<ValorFipeModel>(valoresBoxName);
      return box.get(cacheKey);
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

  @override
  Future<void> saveMesReferencia(MesReferenciaModel mesReferencia) async {
    try {
      final box = await Hive.openBox<Map<dynamic, dynamic>>(
        mesReferenciaBoxName,
      );
      await box.put(mesReferenciaKey, mesReferencia.toJson());
    } catch (e) {
      throw CacheException(
        'Erro ao salvar mês de referência: ${e.toString()}',
      );
    }
  }

  @override
  Future<MesReferenciaModel?> getLocalMesReferencia() async {
    try {
      final box = await Hive.openBox<Map<dynamic, dynamic>>(
        mesReferenciaBoxName,
      );
      final data = box.get(mesReferenciaKey);

      if (data == null) return null;

      // Converte Map<dynamic, dynamic> para Map<String, dynamic>
      final jsonMap = Map<String, dynamic>.from(data);
      return MesReferenciaModel.fromJson(jsonMap);
    } catch (e) {
      throw CacheException(
        'Erro ao recuperar mês de referência: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> saveAllMarcas(List<MarcaModel> marcas) async {
    try {
      // Agrupa marcas por tipo
      final marcasPorTipo = <String, List<MarcaModel>>{};

      for (final marca in marcas) {
        marcasPorTipo[marca.tipo] ??= [];
        marcasPorTipo[marca.tipo]!.add(marca);
      }

      // Salva cada grupo
      final box = await Hive.openBox<List<dynamic>>(marcasBoxName);
      final timesBox = await Hive.openBox<int>(cacheTimesBoxName);
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      for (final entry in marcasPorTipo.entries) {
        await box.put(entry.key, entry.value);
        await timesBox.put('marcas_${entry.key}', timestamp);
      }
    } catch (e) {
      throw CacheException(
        'Erro ao salvar todas as marcas: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> saveAllModelos(List<ModeloModel> modelos, int marcaId) async {
    try {
      final box = await Hive.openBox<List<dynamic>>(modelosBoxName);
      await box.put('marca_$marcaId', modelos);

      final timesBox = await Hive.openBox<int>(cacheTimesBoxName);
      await timesBox.put(
        'modelos_$marcaId',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheException(
        'Erro ao salvar todos os modelos: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> saveSyncVersion(SyncVersionModel syncVersion) async {
    try {
      final box = await Hive.openBox<Map<dynamic, dynamic>>(
        syncVersionBoxName,
      );
      await box.put(syncVersionKey, syncVersion.toJson());
    } catch (e) {
      throw CacheException(
        'Erro ao salvar versão de sincronização: ${e.toString()}',
      );
    }
  }

  @override
  Future<SyncVersionModel?> getLocalSyncVersion() async {
    try {
      final box = await Hive.openBox<Map<dynamic, dynamic>>(
        syncVersionBoxName,
      );
      final data = box.get(syncVersionKey);

      if (data == null) return null;

      final jsonMap = Map<String, dynamic>.from(data);
      return SyncVersionModel.fromJson(jsonMap);
    } catch (e) {
      throw CacheException(
        'Erro ao recuperar versão de sincronização: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> saveAllValoresFipe(List<ValorFipeModel> valores) async {
    try {
      final box = await Hive.openBox<ValorFipeModel>(valoresBoxName);
      final timesBox = await Hive.openBox<int>(cacheTimesBoxName);
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // Salva cada valor com chave composta
      for (final valor in valores) {
        final cacheKey =
            '${valor.tipoVeiculo}_${valor.codigoMarca}_${valor.codigoModelo}_${valor.anoModelo}_${valor.codigoCombustivel}';

        await box.put(cacheKey, valor);
        await timesBox.put('valor_$cacheKey', timestamp);
      }
    } catch (e) {
      throw CacheException(
        'Erro ao salvar todos os valores FIPE: ${e.toString()}',
      );
    }
  }

  @override
  Future<ValorFipeModel?> getValorFipeLocal({
    required int marcaId,
    required int modeloId,
    required int anoModelo,
    required int codigoCombustivel,
    required int tipoVeiculo,
  }) async {
    try {
      final box = await Hive.openBox<ValorFipeModel>(valoresBoxName);
      final cacheKey =
          '${tipoVeiculo}_${marcaId}_${modeloId}_${anoModelo}_$codigoCombustivel';

      return box.get(cacheKey);
    } catch (e) {
      throw CacheException(
        'Erro ao buscar valor FIPE local: ${e.toString()}',
      );
    }
  }
}
