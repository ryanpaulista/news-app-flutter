// Validação automatizada da camada SQLite (mesma do app).
// Roda: dart run tool/db_check.dart
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const _table = 'favorites';

Future<Database> open(String path) {
  return databaseFactory.openDatabase(
    path,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, v) => db.execute('''
        CREATE TABLE $_table (
          id TEXT PRIMARY KEY, title TEXT NOT NULL, author TEXT NOT NULL,
          publishedAt TEXT NOT NULL, imageUrl TEXT NOT NULL,
          note TEXT NOT NULL DEFAULT '', savedAt TEXT NOT NULL
        )'''),
    ),
  );
}

void expect(bool ok, String msg) {
  if (!ok) throw Exception('FALHOU: $msg');
  print('  ok - $msg');
}

Future<void> main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final path = '/tmp/claude-1001/db_check.db';
  await databaseFactory.deleteDatabase(path);

  // 1) cria + insere
  var db = await open(path);
  await db.insert(_table, {
    'id': 'https://news/1',
    'title': 'Notícia de teste',
    'author': 'Reuters',
    'publishedAt': '2026-07-13',
    'imageUrl': '',
    'note': '',
    'savedAt': '2026-07-13T10:00:00',
  });
  print('[INSERT]');
  expect((await db.query(_table)).length == 1, 'inseriu 1 registro');
  await db.close();

  // 2) reabre (simula reiniciar o app) -> dado persiste
  db = await open(path);
  print('[PERSISTÊNCIA após reabrir]');
  var rows = await db.query(_table);
  expect(rows.length == 1, 'registro sobreviveu ao fechar/reabrir');
  expect(rows.first['title'] == 'Notícia de teste', 'título correto');

  // 3) update (nota pessoal)
  await db.update(_table, {'note': 'ler depois'},
      where: 'id = ?', whereArgs: ['https://news/1']);
  rows = await db.query(_table, where: 'id = ?', whereArgs: ['https://news/1']);
  print('[UPDATE]');
  expect(rows.first['note'] == 'ler depois', 'nota atualizada');

  // 4) busca (SQL LIKE)
  print('[SEARCH LIKE]');
  var found = await db.query(_table,
      where: 'title LIKE ? OR note LIKE ?', whereArgs: ['%depois%', '%depois%']);
  expect(found.length == 1, 'busca por "depois" achou na nota');
  found = await db.query(_table,
      where: 'title LIKE ? OR note LIKE ?', whereArgs: ['%xyz%', '%xyz%']);
  expect(found.isEmpty, 'busca sem correspondência retorna vazio');

  // 5) delete
  await db.delete(_table, where: 'id = ?', whereArgs: ['https://news/1']);
  print('[DELETE]');
  expect((await db.query(_table)).isEmpty, 'registro removido');

  await db.close();
  print('\n>>> TODOS OS TESTES PASSARAM <<<');
}
