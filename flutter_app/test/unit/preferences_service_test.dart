import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ra7a/data/local/preferences_service.dart';
import 'package:ra7a/data/local/local_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PreferencesService (Unit)', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('darkMode set/get', () async {
      final prefs = await PreferencesService.create();
      expect(prefs.darkMode, isNull);

      await prefs.setDarkMode(true);
      expect(prefs.darkMode, isTrue);
    });

    test('languageCode set/get', () async {
      final prefs = await PreferencesService.create();
      expect(prefs.languageCode, isNull);

      await prefs.setLanguageCode('fr');
      expect(prefs.languageCode, 'fr');
    });

    test('onboardingSeen defaults false then true', () async {
      final prefs = await PreferencesService.create();
      expect(prefs.onboardingSeen, isFalse);

      await prefs.setOnboardingSeen(true);
      expect(prefs.onboardingSeen, isTrue);
    });

    test('cached lists encode/decode roundtrip', () async {
      final prefs = await PreferencesService.create();
      final items = const [
        CachedItem(id: '1', title: 'T1', status: 'open', category: 'Plumbing'),
        CachedItem(
          id: '2',
          title: 'T2',
          status: 'matched',
          category: 'Painting',
        ),
      ];

      await prefs.setHomeownerDemands(items);
      final loaded = prefs.getHomeownerDemands();
      expect(loaded.length, 2);
      expect(loaded.first.id, '1');
      expect(loaded.last.category, 'Painting');
    });
  });
}
