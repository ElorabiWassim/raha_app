import 'package:sqflite/sqflite.dart';

import 'local_database.dart';
import 'local_models.dart';

class LocalCacheRepository {
  LocalCacheRepository({LocalDatabase? database})
    : _databaseProvider = database ?? LocalDatabase.instance;

  final LocalDatabase _databaseProvider;

  Future<Database> get _db async => _databaseProvider.database;

  Future<void> init() async {
    await _databaseProvider.ensureInitialized();
  }

  Future<void> saveAuthTokens(AuthTokens tokens) async {
    final db = await _db;
    await db.insert(
      'auth_tokens',
      tokens.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<AuthTokens?> getAuthTokens() async {
    final db = await _db;
    final rows = await db.query('auth_tokens', limit: 1);
    if (rows.isEmpty) return null;
    return AuthTokens.fromMap(rows.first);
  }

  Future<void> clearAuthTokens() async {
    final db = await _db;
    await db.delete('auth_tokens');
  }

  Future<void> saveUserProfile(LocalUserProfile profile) async {
    final db = await _db;
    await db.insert(
      'user_profile',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<LocalUserProfile?> getUserProfile() async {
    final db = await _db;
    final rows = await db.query('user_profile', limit: 1);
    if (rows.isEmpty) return null;
    return LocalUserProfile.fromMap(rows.first);
  }

  Future<void> clearUserProfile() async {
    final db = await _db;
    await db.delete('user_profile');
  }

  Future<void> clearAuthData() async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.delete('auth_tokens');
      await txn.delete('user_profile');
    });
  }

  Future<void> saveWilayas(List<StaticItem> wilayas) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.delete('wilayas');
      for (final wilaya in wilayas) {
        await txn.insert(
          'wilayas',
          wilaya.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<StaticItem>> getWilayas() async {
    final db = await _db;
    final rows = await db.query('wilayas', orderBy: 'name ASC');
    return rows.map(StaticItem.fromMap).toList();
  }

  Future<void> saveServiceCategories(List<StaticItem> categories) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.delete('service_categories');
      for (final category in categories) {
        await txn.insert(
          'service_categories',
          category.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<StaticItem>> getServiceCategories() async {
    final db = await _db;
    final rows = await db.query('service_categories', orderBy: 'name ASC');
    return rows.map(StaticItem.fromMap).toList();
  }
}
