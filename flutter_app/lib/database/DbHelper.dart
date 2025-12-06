import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'wilayas.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create table with French and Arabic names
    await db.execute('''
      CREATE TABLE wilayas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name_fr TEXT NOT NULL,
        name_ar TEXT NOT NULL
      )
    ''');

    // List of wilayas with French and Arabic names
    List<Map<String, String>> wilayas = [
      {'name_fr': 'Blida', 'name_ar': 'البليدة'},
      {'name_fr': 'Algiers', 'name_ar': 'الجزائر'},
      {'name_fr': 'Oran', 'name_ar': 'وهران'},
    ];

    // Insert each wilaya into the database
    for (var wilaya in wilayas) {
      await db.insert('wilayas', wilaya);
    }
  }

  // Fetch all wilayas
  Future<List<Map<String, dynamic>>> getWilayas() async {
    final db = await database;
    return db.query('wilayas');
  }
}
