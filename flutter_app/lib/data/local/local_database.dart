import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static const _dbName = 'raha_local.db';
  static const _dbVersion = 4; // Incremented for new tables

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
      onUpgrade: _onUpgrade,
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
        email TEXT,
        phone_number TEXT,
        address TEXT,
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

    // Create new tables for v2
    if (version >= 2) {
      await _createV2Tables(db);
    }
    if (version >= 3) {
      await _createV3Tables(db);
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createV2Tables(db);
    }
    if (oldVersion < 3) {
      await _createV3Tables(db);
    }
    if (oldVersion < 4) {
      await _migrateUserProfileV4(db);
    }
  }

  Future<void> _createV2Tables(Database db) async {
    // Cached bookings table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cached_bookings(
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        provider_name TEXT,
        provider_image TEXT,
        service_name TEXT,
        date_time TEXT,
        price TEXT,
        status TEXT,
        cached_at INTEGER NOT NULL,
        data_json TEXT NOT NULL
      )
    ''');

    // Cached demands table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cached_demands(
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        title TEXT,
        category TEXT,
        status TEXT,
        posted_date TEXT,
        cached_at INTEGER NOT NULL,
        data_json TEXT NOT NULL
      )
    ''');

    // Cached conversations table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cached_conversations(
        conversation_id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        other_user_name TEXT,
        other_user_image TEXT,
        last_message TEXT,
        last_message_at INTEGER,
        unread_count INTEGER DEFAULT 0,
        cached_at INTEGER NOT NULL,
        data_json TEXT NOT NULL
      )
    ''');

    // Cached messages table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cached_messages(
        message_id TEXT PRIMARY KEY,
        conversation_id TEXT NOT NULL,
        sender_id TEXT NOT NULL,
        sender_name TEXT,
        content TEXT,
        sent_at INTEGER,
        is_read INTEGER DEFAULT 0,
        cached_at INTEGER NOT NULL,
        data_json TEXT NOT NULL,
        FOREIGN KEY (conversation_id) REFERENCES cached_conversations(conversation_id)
      )
    ''');
  }

  Future<void> _createV3Tables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_settings(
        user_id TEXT PRIMARY KEY,
        language_code TEXT,
        updated_at INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _migrateUserProfileV4(Database db) async {
    await db.execute('ALTER TABLE user_profile ADD COLUMN email TEXT');
    await db.execute('ALTER TABLE user_profile ADD COLUMN phone_number TEXT');
    await db.execute('ALTER TABLE user_profile ADD COLUMN address TEXT');
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
