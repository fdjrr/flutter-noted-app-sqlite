import 'package:noted_app_sqlite/data/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqflite.dart';

class LocalDataSource {
  final String dbName = 'notes_app.db';
  final String tableName = 'notes';

  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          content TEXT,
          createdAt TEXT)''',
        );
      },
    );
  }

  Future<int> insertNote(Note note) async {
    final db = await _openDatabase();
    return await db.insert(tableName, note.toMap());
  }

  Future<List<Note>> getNotes() async {
    final db = await _openDatabase();
    final maps = await db.query(tableName, orderBy: 'createdAt DESC');
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<Note> getNoteById(int id) async {
    final db = await _openDatabase();
    final maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return Note.fromMap(maps.first);
  }

  Future<int> updateNote(Note note) async {
    final db = await _openDatabase();
    return await db.update(
      tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await _openDatabase();
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
