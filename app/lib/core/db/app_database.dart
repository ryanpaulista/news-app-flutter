import 'package:app/core/models/favorite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const _table = 'favorites';
  Database? _db;

  Future<Database> get _database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'newshub.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            author TEXT NOT NULL,
            publishedAt TEXT NOT NULL,
            imageUrl TEXT NOT NULL,
            note TEXT NOT NULL DEFAULT '',
            savedAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insert(Favorite favorite) async {
    final db = await _database;
    await db.insert(
      _table,
      favorite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Favorite>> getAll() async {
    final db = await _database;
    final rows = await db.query(_table, orderBy: 'savedAt DESC');
    return rows.map(Favorite.fromMap).toList();
  }

  Future<void> update(Favorite favorite) async {
    final db = await _database;
    await db.update(
      _table,
      favorite.toMap(),
      where: 'id = ?',
      whereArgs: [favorite.id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _database;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> exists(String id) async {
    final db = await _database;
    final rows = await db.query(_table, where: 'id = ?', whereArgs: [id]);
    return rows.isNotEmpty;
  }

  // Desafio: busca local por título ou nota usando SQL LIKE.
  Future<List<Favorite>> search(String query) async {
    final db = await _database;
    final rows = await db.query(
      _table,
      where: 'title LIKE ? OR note LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'savedAt DESC',
    );
    return rows.map(Favorite.fromMap).toList();
  }
}
