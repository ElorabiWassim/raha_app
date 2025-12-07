import 'dart:convert';
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

  Future<LocalUserProfile?> getUserProfile({String? userId}) async {
    final db = await _db;
    final rows = await db.query(
      'user_profile',
      where: userId != null ? 'user_id = ?' : null,
      whereArgs: userId != null ? [userId] : null,
      orderBy: 'updated_at DESC',
      limit: 1,
    );
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
      await txn.delete('user_settings');
    });
  }

  Future<void> saveUserLanguage(String userId, String languageCode) async {
    final db = await _db;
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.insert('user_settings', {
      'user_id': userId,
      'language_code': languageCode,
      'updated_at': now,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getUserLanguage(String userId) async {
    final db = await _db;
    final rows = await db.query(
      'user_settings',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['language_code'] as String?;
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

  // ========== Cached Bookings ==========

  Future<void> saveBookings(
    String userId,
    List<Map<String, dynamic>> bookings,
  ) async {
    final db = await _db;
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.transaction((txn) async {
      // Clear old bookings for this user
      await txn.delete(
        'cached_bookings',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      // Insert new bookings
      for (final booking in bookings) {
        await txn.insert('cached_bookings', {
          'id': booking['id'],
          'user_id': userId,
          'provider_name': booking['providerName'],
          'provider_image': booking['providerImage'],
          'service_name': booking['serviceName'],
          'date_time': booking['dateTime'],
          'price': booking['price'],
          'status': booking['status'],
          'cached_at': now,
          'data_json': jsonEncode(booking),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getBookings(String userId) async {
    final db = await _db;
    final rows = await db.query(
      'cached_bookings',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'cached_at DESC',
    );

    return rows.map((row) {
      return jsonDecode(row['data_json'] as String) as Map<String, dynamic>;
    }).toList();
  }

  // ========== Cached Demands ==========

  Future<void> saveDemands(
    String userId,
    List<Map<String, dynamic>> demands,
  ) async {
    final db = await _db;
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.transaction((txn) async {
      // Clear old demands for this user
      await txn.delete(
        'cached_demands',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      // Insert new demands
      for (final demand in demands) {
        await txn.insert('cached_demands', {
          'id': demand['id'] ?? demand['title'], // Use title as fallback ID
          'user_id': userId,
          'title': demand['title'],
          'category': demand['category'],
          'status': demand['status'],
          'posted_date': demand['postedDate'],
          'cached_at': now,
          'data_json': jsonEncode(demand),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getDemands(String userId) async {
    final db = await _db;
    final rows = await db.query(
      'cached_demands',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'cached_at DESC',
    );

    return rows.map((row) {
      return jsonDecode(row['data_json'] as String) as Map<String, dynamic>;
    }).toList();
  }

  // ========== Cached Conversations ==========

  Future<void> saveConversations(
    String userId,
    List<Map<String, dynamic>> conversations,
  ) async {
    final db = await _db;
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.transaction((txn) async {
      // Clear old conversations for this user
      await txn.delete(
        'cached_conversations',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      // Insert new conversations
      for (final conv in conversations) {
        await txn.insert('cached_conversations', {
          'conversation_id': conv['conversationId'],
          'user_id': userId,
          'other_user_name': conv['otherUserName'],
          'other_user_image': conv['otherUserImage'],
          'last_message': conv['lastMessage'],
          'last_message_at': conv['lastMessageAt'],
          'unread_count': conv['unreadCount'] ?? 0,
          'cached_at': now,
          'data_json': jsonEncode(conv),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getConversations(String userId) async {
    final db = await _db;
    final rows = await db.query(
      'cached_conversations',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'last_message_at DESC',
    );

    return rows.map((row) {
      return jsonDecode(row['data_json'] as String) as Map<String, dynamic>;
    }).toList();
  }

  // ========== Cached Messages ==========

  Future<void> saveMessages(
    String conversationId,
    List<Map<String, dynamic>> messages,
  ) async {
    final db = await _db;
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.transaction((txn) async {
      // Clear old messages for this conversation
      await txn.delete(
        'cached_messages',
        where: 'conversation_id = ?',
        whereArgs: [conversationId],
      );

      // Insert new messages
      for (final msg in messages) {
        await txn.insert('cached_messages', {
          'message_id': msg['messageId'],
          'conversation_id': conversationId,
          'sender_id': msg['senderId'],
          'sender_name': msg['senderName'],
          'content': msg['content'],
          'sent_at': msg['sentAt'],
          'is_read': msg['isRead'] == true ? 1 : 0,
          'cached_at': now,
          'data_json': jsonEncode(msg),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    final db = await _db;
    final rows = await db.query(
      'cached_messages',
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      orderBy: 'sent_at ASC',
    );

    return rows.map((row) {
      return jsonDecode(row['data_json'] as String) as Map<String, dynamic>;
    }).toList();
  }

  // Helper to check if cached data exists
  Future<bool> hasCachedBookings(String userId) async {
    final db = await _db;
    final result = await db.query(
      'cached_bookings',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<bool> hasCachedDemands(String userId) async {
    final db = await _db;
    final result = await db.query(
      'cached_demands',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}
