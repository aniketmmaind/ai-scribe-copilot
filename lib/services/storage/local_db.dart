import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDb {
  static Database? _db;
  static final LocalDb instance = LocalDb._internal();
  LocalDb._internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'medinote.db');
    _db = await openDatabase(
      path,
      version: 2,
      onCreate: (d, v) async {
        await d.execute('''
        CREATE TABLE pending_chunks (
          id TEXT PRIMARY KEY,
          sessionId TEXT,
          chunkNumber INTEGER,
          localFilePath TEXT,
          gcsPath TEXT,
          publicUrl TEXT,
          mimeType TEXT,
          isLast INTEGER,
          attempts INTEGER,
          liveTranscript TEXT,
          status TEXT,
          createdAt INTEGER
        )
      ''');
      },
    );
    return _db!;
  }

  Future<void> insert(String table, Map<String, dynamic> values) async {
    final d = await db;
    await d.insert(table, values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final d = await db;
    return d.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: 'chunkNumber ASC',
    );
  }

  Future<void> delete(
    String table,
    String where,
    List<dynamic> whereArgs,
  ) async {
    final d = await db;
    await d.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<void> update(
    String table,
    Map<String, dynamic> values,
    String where,
    List<dynamic> whereArgs,
  ) async {
    final d = await db;
    await d.update(table, values, where: where, whereArgs: whereArgs);
  }
}
