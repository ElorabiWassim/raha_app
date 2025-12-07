import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static const _dbName = 'raha_local.db';
  static const _dbVersion = 1;

  static final LocalDatabase instance = LocalDatabase._internal();

  Database? _database;

  LocalDatabase._internal();

  Future<void> ensureInitialized() async {
    await database;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    final path = join(await getDatabasesPath(), _dbName);
    _database = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE auth_tokens(
        id INTEGER PRIMARY KEY,
        access_token TEXT NOT NULL,
        refresh_token TEXT NOT NULL,
        user_id TEXT NOT NULL,
        user_role TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_profile(
        user_id TEXT PRIMARY KEY,
        full_name TEXT NOT NULL,
        role TEXT NOT NULL,
        profile_image_url TEXT,
        updated_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE wilayas(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE service_categories(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        parent_id TEXT
      )
    ''');
  }

  Future<void> clearTable(String table) async {
    final db = await database;
    await db.delete(table);
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
