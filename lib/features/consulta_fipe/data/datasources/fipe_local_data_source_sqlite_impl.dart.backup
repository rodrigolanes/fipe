import 'dart:developer' as dev;

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/marca_model.dart';
import '../models/mes_referencia_model.dart';
import '../models/modelo_model.dart';
import '../models/sync_version_model.dart';
import '../models/valor_fipe_model.dart';
import 'fipe_local_data_source.dart';

/// Implementação SQLite do Local Data Source
///
/// MUITO mais eficiente que Hive para grandes volumes de dados:
/// - Transações em lote extremamente rápidas
/// - Indices otimizados para queries complexas
/// - Queries SQL nativas com joins
/// - Sem travamentos na UI durante gravação em massa
class FipeLocalDataSourceSqliteImpl implements FipeLocalDataSource {
  static const String _databaseName = 'fipe_local.db';
  static const int _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela de marcas (cache por tipo)
    await db.execute('''
      CREATE TABLE marcas_cache (
        tipo TEXT NOT NULL,
        codigo INTEGER NOT NULL,
        nome TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        PRIMARY KEY (tipo, codigo)
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_marcas_tipo ON marcas_cache(tipo)
    ''');

    // Tabela de modelos (cache por marca)
    await db.execute('''
      CREATE TABLE modelos_cache (
        marca_id INTEGER NOT NULL,
        codigo INTEGER NOT NULL,
        nome TEXT NOT NULL,
        tipo TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        PRIMARY KEY (marca_id, codigo)
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_modelos_marca ON modelos_cache(marca_id)
    ''');

    // Tabela de valores FIPE (sync completo)
    await db.execute('''
      CREATE TABLE valores_fipe (
        tipo_veiculo INTEGER NOT NULL,
        codigo_marca INTEGER NOT NULL,
        codigo_modelo INTEGER NOT NULL,
        ano_modelo INTEGER NOT NULL,
        codigo_combustivel INTEGER NOT NULL,
        marca TEXT NOT NULL,
        modelo TEXT NOT NULL,
        combustivel TEXT NOT NULL,
        codigo_fipe TEXT NOT NULL,
        mes_referencia TEXT NOT NULL,
        valor TEXT NOT NULL,
        data_consulta TEXT NOT NULL,
        PRIMARY KEY (tipo_veiculo, codigo_marca, codigo_modelo, ano_modelo, codigo_combustivel)
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_valores_marca ON valores_fipe(codigo_marca)
    ''');

    await db.execute('''
      CREATE INDEX idx_valores_modelo ON valores_fipe(codigo_modelo)
    ''');

    // Tabela de sync version
    await db.execute('''
      CREATE TABLE sync_version (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        version TEXT NOT NULL,
        mes_referencia TEXT NOT NULL,
        data_atualizacao TEXT NOT NULL,
        total_marcas INTEGER NOT NULL DEFAULT 0,
        total_modelos INTEGER NOT NULL DEFAULT 0,
        total_valores INTEGER NOT NULL DEFAULT 0,
        carga_concluida INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Tabela de timestamps de cache
    await db.execute('''
      CREATE TABLE cache_times (
        key TEXT PRIMARY KEY,
        timestamp INTEGER NOT NULL
      )
    ''');
  }

  @override
  Future<void> cacheMarcas(List<MarcaModel> marcas, TipoVeiculo tipo) async {
    try {
      final db = await database;
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await db.transaction((txn) async {
        // Remove marcas antigas do tipo
        await txn
            .delete('marcas_cache', where: 'tipo = ?', whereArgs: [tipo.nome]);

        // Insere novas marcas em lote
        final batch = txn.batch();
        for (final marca in marcas) {
          batch.insert('marcas_cache', {
            'tipo': tipo.nome,
            'codigo': marca.id,
            'nome': marca.nome,
            'timestamp': timestamp,
          });
        }
        await batch.commit(noResult: true);

        // Atualiza timestamp do cache
        await txn.insert(
          'cache_times',
          {'key': 'marcas_${tipo.nome}', 'timestamp': timestamp},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      throw CacheException('Erro ao salvar marcas em cache: ${e.toString()}');
    }
  }

  @override
  Future<List<MarcaModel>> getCachedMarcas(TipoVeiculo tipo) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'marcas_cache',
        where: 'tipo = ?',
        whereArgs: [tipo.nome],
        orderBy: 'nome',
      );

      if (maps.isEmpty) {
        throw CacheException('Nenhuma marca encontrada no cache');
      }

      return maps
          .map((map) => MarcaModel(
                id: map['codigo'] as int,
                nome: map['nome'] as String,
                tipo: map['tipo'] as String,
              ))
          .toList();
    } catch (e) {
      throw CacheException(
          'Erro ao recuperar marcas do cache: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheModelos(List<ModeloModel> modelos, int marcaId) async {
    try {
      final db = await database;
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await db.transaction((txn) async {
        // Remove modelos antigos da marca
        await txn.delete('modelos_cache',
            where: 'marca_id = ?', whereArgs: [marcaId]);

        // Insere novos modelos em lote
        final batch = txn.batch();
        for (final modelo in modelos) {
          batch.insert('modelos_cache', {
            'marca_id': marcaId,
            'codigo': modelo.id,
            'nome': modelo.nome,
            'tipo': modelo.tipo,
            'timestamp': timestamp,
          });
        }
        await batch.commit(noResult: true);

        // Atualiza timestamp do cache
        await txn.insert(
          'cache_times',
          {'key': 'modelos_$marcaId', 'timestamp': timestamp},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      throw CacheException('Erro ao salvar modelos em cache: ${e.toString()}');
    }
  }

  @override
  Future<List<ModeloModel>> getCachedModelos(int marcaId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'modelos_cache',
        where: 'marca_id = ?',
        whereArgs: [marcaId],
        orderBy: 'nome',
      );

      if (maps.isEmpty) {
        throw CacheException('Nenhum modelo encontrado no cache');
      }

      return maps
          .map((map) => ModeloModel(
                id: map['codigo'] as int,
                marcaId: map['marca_id'] as int,
                nome: map['nome'] as String,
                tipo: map['tipo'] as String,
              ))
          .toList();
    } catch (e) {
      throw CacheException(
          'Erro ao recuperar modelos do cache: ${e.toString()}');
    }
  }

  @override
  Future<bool> isCacheValid(String cacheKey) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'cache_times',
        where: 'key = ?',
        whereArgs: [cacheKey],
      );

      if (maps.isEmpty) return false;

      final timestamp = maps.first['timestamp'] as int;
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      return now.difference(cacheTime).inSeconds < AppConstants.cacheTimeout;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearAllLocalData() async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.delete('valores_fipe');
        await txn.delete('marcas_cache');
        await txn.delete('modelos_cache');
        await txn.delete('cache_times');
        await txn.delete('sync_version');
      });
    } catch (e) {
      throw CacheException('Erro ao limpar dados locais: ${e.toString()}');
    }
  }

  @override
  Future<void> saveAllMarcas(List<MarcaModel> marcas) async {
    try {
      final db = await database;
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await db.transaction((txn) async {
        // Remove todas as marcas antigas
        await txn.delete('marcas_cache');

        // Insere todas as marcas em lote usando batch
        final batch = txn.batch();
        for (final marca in marcas) {
          batch.insert('marcas_cache', {
            'tipo': marca.tipo,
            'codigo': marca.id,
            'nome': marca.nome,
            'timestamp': timestamp,
          });
        }
        await batch.commit(noResult: true);

        // Atualiza timestamp
        await txn.insert(
          'cache_times',
          {'key': 'all_marcas_sync', 'timestamp': timestamp},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      throw CacheException('Erro ao salvar todas as marcas: ${e.toString()}');
    }
  }

  @override
  Future<void> saveAllValoresFipe(List<ValorFipeModel> valores) async {
    try {
      final db = await database;

      // Chunks MINÚSCULOS (50) para UI extremamente responsiva
      // Mesmo que demore mais, prioridade é não travar
      const chunkSize = 50;
      final totalChunks = (valores.length / chunkSize).ceil();

      for (var i = 0; i < valores.length; i += chunkSize) {
        final end =
            (i + chunkSize < valores.length) ? i + chunkSize : valores.length;
        final chunk = valores.sublist(i, end);
        final chunkNumber = (i / chunkSize).floor() + 1;

        await db.transaction((txn) async {
          final batch = txn.batch();
          for (final valor in chunk) {
            batch.insert(
              'valores_fipe',
              {
                'tipo_veiculo': valor.tipoVeiculo,
                'codigo_marca': valor.codigoMarca,
                'codigo_modelo': valor.codigoModelo,
                'ano_modelo': valor.anoModelo,
                'codigo_combustivel': valor.codigoCombustivel,
                'marca': valor.marca,
                'modelo': valor.modelo,
                'combustivel': valor.combustivel,
                'codigo_fipe': valor.codigoFipe,
                'mes_referencia': valor.mesReferencia,
                'valor': valor.valor,
                'data_consulta': valor.dataConsulta.toIso8601String(),
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
          await batch.commit(noResult: true);
        });

        // Log de progresso a cada 20 chunks
        if (chunkNumber % 20 == 0 || chunkNumber == totalChunks) {
          dev.log(
              '💾 Progresso: $chunkNumber/$totalChunks chunks (${(chunkNumber / totalChunks * 100).toStringAsFixed(1)}%)',
              name: 'FipeLocalCache');
        }

        // Delay de 150ms para UI ter MUITO tempo de processar
        // 60fps = 16.67ms por frame, então 150ms = 9 frames de folga
        await Future.delayed(const Duration(milliseconds: 150));
      }

      // Salva timestamp geral
      await db.insert(
        'cache_times',
        {
          'key': 'valores_sync',
          'timestamp': DateTime.now().millisecondsSinceEpoch
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      dev.log('✅ Total de ${valores.length} valores salvos com sucesso!',
          name: 'FipeLocalCache');
    } catch (e) {
      throw CacheException('Erro ao salvar valores FIPE: ${e.toString()}');
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
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'valores_fipe',
        where: '''
          tipo_veiculo = ? AND 
          codigo_marca = ? AND 
          codigo_modelo = ? AND 
          ano_modelo = ? AND 
          codigo_combustivel = ?
        ''',
        whereArgs: [
          tipoVeiculo,
          marcaId,
          modeloId,
          anoModelo,
          codigoCombustivel
        ],
      );

      if (maps.isEmpty) return null;

      final map = maps.first;
      return ValorFipeModel(
        marca: map['marca'] as String,
        modelo: map['modelo'] as String,
        anoModelo: map['ano_modelo'] as int,
        combustivel: map['combustivel'] as String,
        codigoFipe: map['codigo_fipe'] as String,
        mesReferencia: map['mes_referencia'] as String,
        valor: map['valor'] as String,
        dataConsulta: DateTime.parse(map['data_consulta'] as String),
        tipoVeiculo: map['tipo_veiculo'] as int,
        codigoMarca: map['codigo_marca'] as int,
        codigoModelo: map['codigo_modelo'] as int,
        codigoCombustivel: map['codigo_combustivel'] as int,
      );
    } catch (e) {
      // Se houver erro (ex: tabela não existe ainda, banco corrompido),
      // retorna null para que o sistema tente buscar online
      dev.log(
          'Aviso: Erro ao buscar valor local, tentará buscar online: ${e.toString()}',
          name: 'FipeLocalCache');
      return null;
    }
  }

  @override
  Future<void> saveSyncVersion(SyncVersionModel syncVersion) async {
    try {
      final db = await database;
      await db.insert(
        'sync_version',
        {
          'id': 1,
          'version': syncVersion.version,
          'mes_referencia': syncVersion.mesReferencia,
          'data_atualizacao': syncVersion.dataAtualizacao.toIso8601String(),
          'total_marcas': syncVersion.totalMarcas,
          'total_modelos': syncVersion.totalModelos,
          'total_valores': syncVersion.totalValores,
          'carga_concluida': syncVersion.cargaConcluida ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException('Erro ao salvar versão de sync: ${e.toString()}');
    }
  }

  @override
  Future<SyncVersionModel?> getLocalSyncVersion() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('sync_version');

      if (maps.isEmpty) return null;

      final map = maps.first;
      return SyncVersionModel(
        version: map['version'] as String,
        mesReferencia: map['mes_referencia'] as String,
        dataAtualizacao: DateTime.parse(map['data_atualizacao'] as String),
        totalMarcas: map['total_marcas'] as int,
        totalModelos: map['total_modelos'] as int,
        totalValores: map['total_valores'] as int,
        cargaConcluida: (map['carga_concluida'] as int) == 1,
      );
    } catch (e) {
      throw CacheException('Erro ao buscar versão local: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheValorFipe(ValorFipeModel valor, String cacheKey) async {
    try {
      final db = await database;
      await db.insert(
        'valores_fipe',
        {
          'tipo_veiculo': valor.tipoVeiculo,
          'codigo_marca': valor.codigoMarca,
          'codigo_modelo': valor.codigoModelo,
          'ano_modelo': valor.anoModelo,
          'codigo_combustivel': valor.codigoCombustivel,
          'marca': valor.marca,
          'modelo': valor.modelo,
          'combustivel': valor.combustivel,
          'codigo_fipe': valor.codigoFipe,
          'mes_referencia': valor.mesReferencia,
          'valor': valor.valor,
          'data_consulta': valor.dataConsulta.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException('Erro ao salvar valor FIPE: ${e.toString()}');
    }
  }

  @override
  Future<ValorFipeModel?> getCachedValorFipe(String cacheKey) async {
    try {
      final db = await database;
      // Cache key format: {tipo}_{marca}_{modelo}_{ano}_{combustivel}
      final parts = cacheKey.split('_');
      if (parts.length != 5) return null;

      final List<Map<String, dynamic>> maps = await db.query(
        'valores_fipe',
        where: '''
          tipo_veiculo = ? AND 
          codigo_marca = ? AND 
          codigo_modelo = ? AND 
          ano_modelo = ? AND 
          codigo_combustivel = ?
        ''',
        whereArgs: [
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
          int.parse(parts[3]),
          int.parse(parts[4]),
        ],
      );

      if (maps.isEmpty) return null;

      final map = maps.first;
      return ValorFipeModel(
        marca: map['marca'] as String,
        modelo: map['modelo'] as String,
        anoModelo: map['ano_modelo'] as int,
        combustivel: map['combustivel'] as String,
        codigoFipe: map['codigo_fipe'] as String,
        mesReferencia: map['mes_referencia'] as String,
        valor: map['valor'] as String,
        dataConsulta: DateTime.parse(map['data_consulta'] as String),
        tipoVeiculo: map['tipo_veiculo'] as int,
        codigoMarca: map['codigo_marca'] as int,
        codigoModelo: map['codigo_modelo'] as int,
        codigoCombustivel: map['codigo_combustivel'] as int,
      );
    } catch (e) {
      // Se houver erro, retorna null para que o sistema tente buscar online
      dev.log(
          'Aviso: Erro ao buscar valor do cache, tentará buscar online: ${e.toString()}',
          name: 'FipeLocalCache');
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.delete('marcas_cache');
        await txn.delete('modelos_cache');
        await txn.delete('cache_times');
        // Não remove valores_fipe e sync_version (dados de sincronização)
      });
    } catch (e) {
      throw CacheException('Erro ao limpar cache: ${e.toString()}');
    }
  }

  @override
  Future<MesReferenciaModel?> getLocalMesReferencia() async {
    try {
      // Retorna da sync_version convertida para MesReferencia
      final syncVersion = await getLocalSyncVersion();
      if (syncVersion == null) return null;

      return MesReferenciaModel(
        id: syncVersion.version,
        nomeFormatado: syncVersion.mesReferencia,
        dataAtualizacao: syncVersion.dataAtualizacao,
      );
    } catch (e) {
      throw CacheException('Erro ao buscar mes referencia: ${e.toString()}');
    }
  }

  @override
  Future<void> saveMesReferencia(MesReferenciaModel mesReferencia) async {
    // Não implementado - MesReferencia é parte da sync_version
    // Use saveSyncVersion ao invés
    return Future.value();
  }

  @override
  Future<void> saveAllModelos(List<ModeloModel> modelos, int marcaId) async {
    try {
      final db = await database;
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await db.transaction((txn) async {
        // Remove modelos antigos da marca
        await txn.delete('modelos_cache',
            where: 'marca_id = ?', whereArgs: [marcaId]);

        // Insere novos modelos em lote
        final batch = txn.batch();
        for (final modelo in modelos) {
          batch.insert('modelos_cache', {
            'marca_id': marcaId,
            'codigo': modelo.id,
            'nome': modelo.nome,
            'tipo': modelo.tipo,
            'timestamp': timestamp,
          });
        }
        await batch.commit(noResult: true);

        // Atualiza timestamp
        await txn.insert(
          'cache_times',
          {'key': 'modelos_$marcaId', 'timestamp': timestamp},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      throw CacheException('Erro ao salvar modelos: ${e.toString()}');
    }
  }

  // Método de limpeza/fechamento
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
