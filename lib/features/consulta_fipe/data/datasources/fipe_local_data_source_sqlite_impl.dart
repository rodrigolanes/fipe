import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/marca_model.dart';
import '../models/modelo_model.dart';
import 'fipe_local_data_source.dart';

/// Implementação SQLite do Local Data Source
///
/// Cache leve apenas para marcas e modelos (dados estáveis).
/// Valores FIPE são buscados sempre online para garantir atualização.
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
      throw CacheException('Erro ao salvar marcas: ${e.toString()}');
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
        orderBy: 'nome ASC',
      );

      return maps
          .map((map) => MarcaModel(
                id: map['codigo'] as int,
                nome: map['nome'] as String,
                tipo: map['tipo'] as String,
              ))
          .toList();
    } catch (e) {
      throw CacheException('Erro ao buscar marcas: ${e.toString()}');
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
      throw CacheException('Erro ao salvar modelos: ${e.toString()}');
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
        orderBy: 'nome ASC',
      );

      return maps
          .map((map) => ModeloModel(
                id: map['codigo'] as int,
                nome: map['nome'] as String,
                tipo: map['tipo'] as String,
                marcaId: map['marca_id'] as int,
              ))
          .toList();
    } catch (e) {
      throw CacheException('Erro ao buscar modelos: ${e.toString()}');
    }
  }

  @override
  Future<bool> isCacheValid(String key) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query(
        'cache_times',
        where: 'key = ?',
        whereArgs: [key],
        limit: 1,
      );

      if (result.isEmpty) return false;

      final timestamp = result.first['timestamp'] as int;
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      return now.difference(cacheTime).inSeconds < AppConstants.cacheTimeout;
    } catch (e) {
      return false;
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
      });
    } catch (e) {
      throw CacheException('Erro ao limpar cache: ${e.toString()}');
    }
  }
}
