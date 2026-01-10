import 'package:flutter_test/flutter_test.dart';

import 'package:ra7a/data/local/local_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Local models (Unit)', () {
    test('AuthTokens toMap/fromMap roundtrip', () {
      final tokens = AuthTokens(
        accessToken: 'a',
        refreshToken: 'r',
        userId: 'u1',
        userRole: 'homeowner',
        updatedAt: 123,
      );

      final map = tokens.toMap();
      final parsed = AuthTokens.fromMap(map);

      expect(parsed.accessToken, 'a');
      expect(parsed.refreshToken, 'r');
      expect(parsed.userId, 'u1');
      expect(parsed.userRole, 'homeowner');
      expect(parsed.updatedAt, 123);
    });

    test('LocalUserProfile toMap/fromMap roundtrip', () {
      final profile = LocalUserProfile(
        userId: 'u1',
        fullName: 'Test User',
        role: 'homeowner',
        profileImageUrl: 'https://example.com/p.png',
        updatedAt: 999,
      );

      final map = profile.toMap();
      final parsed = LocalUserProfile.fromMap(map);

      expect(parsed.userId, 'u1');
      expect(parsed.fullName, 'Test User');
      expect(parsed.role, 'homeowner');
      expect(parsed.profileImageUrl, 'https://example.com/p.png');
      expect(parsed.updatedAt, 999);
    });

    test('CachedItem encodeList/decodeList roundtrip', () {
      const items = [
        CachedItem(id: '1', title: 'T1', status: 'open', category: 'Plumbing'),
        CachedItem(id: '2', title: null, status: null, category: null),
      ];

      final encoded = CachedItem.encodeList(items);
      final decoded = CachedItem.decodeList(encoded);

      expect(decoded.length, 2);
      expect(decoded[0].id, '1');
      expect(decoded[0].title, 'T1');
      expect(decoded[1].id, '2');
      expect(decoded[1].title, isNull);
    });

    test('CachedItem.decodeList returns empty list for null/empty', () {
      expect(CachedItem.decodeList(null), isEmpty);
      expect(CachedItem.decodeList(''), isEmpty);
    });
  });
}
