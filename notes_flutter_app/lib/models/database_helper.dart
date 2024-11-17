import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'notes.db');
    return await openDatabase(
      path,
      version: 7,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY,
        name TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY,
        title TEXT,
        content TEXT,
        category_id INTEGER,
        imagePath TEXT,
        color INTEGER,
        tasks TEXT,
        reminder INTEGER,
        FOREIGN KEY(category_id) REFERENCES categories(id)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE notes ADD COLUMN content TEXT;
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        ALTER TABLE notes ADD COLUMN category_id INTEGER;
      ''');
    }
    if (oldVersion < 4) {
      await db.execute('''
        ALTER TABLE notes ADD COLUMN imagePath TEXT;
      ''');
    }
    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE categories(
          id INTEGER PRIMARY KEY,
          name TEXT
        )
      ''');
      await db.execute('''
        ALTER TABLE notes ADD COLUMN category_id INTEGER;
      ''');
    }
    if (oldVersion < 6) {
      await db.execute('''
        ALTER TABLE notes ADD COLUMN color INTEGER;
      ''');
    }
    if (oldVersion < 7) {
      await db.execute('''
        ALTER TABLE notes ADD COLUMN tasks TEXT;
      ''');
      await db.execute('''
        ALTER TABLE notes ADD COLUMN reminder INTEGER;
      ''');
    }
  }

  Future<int> insertNote(Map<String, dynamic> row) async {
    final db = await database;
    return await db!.insert('notes', row);
  }



  Future<int> updateNote(Map<String, dynamic> row) async {
    final db = await database;
    int id = row['id'];
    return await db!.update('notes', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db!.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertCategory(Map<String, dynamic> row) async {
    final db = await database;
    return await db!.insert('categories', row);
  }

  Future<List<Map<String, dynamic>>> queryAllCategories() async {
    final db = await database;
    return await db!.query('categories');
  }

  Future<int> updateCategory(Map<String, dynamic> row) async {
    final db = await database;
    int id = row['id'];
    return await db!
        .update('categories', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db!.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

    Future<List<Map<String, dynamic>>> queryAllNotes() async {
    final db = await database;
    return await db!.rawQuery('''
      SELECT notes.*, categories.name AS category_name
      FROM notes
      JOIN categories ON notes.category_id = categories.id
    ''');
  }
}
