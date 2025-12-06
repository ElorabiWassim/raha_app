import 'package:shared_preferences/shared_preferences.dart';

import 'local_models.dart';

class PreferencesService {
  PreferencesService._(this._prefs);

  final SharedPreferences _prefs;

  static const _keyDarkMode = 'pref_dark_mode';
  static const _keyLanguage = 'pref_language_code';
  static const _keyOnboarding = 'pref_onboarding_shown';
  static const _keyLastOpenedTab = 'pref_last_opened_tab';
  static const _keyNotificationsEnabled = 'pref_notifications_enabled';
  static const _keyHomeownerServices = 'pref_homeowner_services';
  static const _keyHomeownerProviders = 'pref_homeowner_providers';
  static const _keyHomeownerDemands = 'pref_homeowner_demands';
  static const _keyHomeownerBookings = 'pref_homeowner_bookings';
  static const _keySpDemands = 'pref_sp_demands';
  static const _keySpBookings = 'pref_sp_bookings';

  static Future<PreferencesService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService._(prefs);
  }

  bool? get darkMode => _prefs.getBool(_keyDarkMode);
  Future<void> setDarkMode(bool enabled) async {
    await _prefs.setBool(_keyDarkMode, enabled);
  }

  String? get languageCode => _prefs.getString(_keyLanguage);
  Future<void> setLanguageCode(String code) async {
    await _prefs.setString(_keyLanguage, code);
  }

  bool get onboardingSeen => _prefs.getBool(_keyOnboarding) ?? false;
  Future<void> setOnboardingSeen(bool seen) async {
    await _prefs.setBool(_keyOnboarding, seen);
  }

  String? get lastOpenedTab => _prefs.getString(_keyLastOpenedTab);
  Future<void> setLastOpenedTab(String tab) async {
    await _prefs.setString(_keyLastOpenedTab, tab);
  }

  bool get notificationsEnabled =>
      _prefs.getBool(_keyNotificationsEnabled) ?? true;
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_keyNotificationsEnabled, enabled);
  }

  Future<void> setHomeownerServices(List<CachedItem> items) async {
    await _prefs.setString(_keyHomeownerServices, CachedItem.encodeList(items));
  }

  List<CachedItem> getHomeownerServices() {
    return CachedItem.decodeList(_prefs.getString(_keyHomeownerServices));
  }

  Future<void> setHomeownerProviders(List<CachedItem> items) async {
    await _prefs.setString(
      _keyHomeownerProviders,
      CachedItem.encodeList(items),
    );
  }

  List<CachedItem> getHomeownerProviders() {
    return CachedItem.decodeList(_prefs.getString(_keyHomeownerProviders));
  }

  Future<void> setHomeownerDemands(List<CachedItem> items) async {
    await _prefs.setString(_keyHomeownerDemands, CachedItem.encodeList(items));
  }

  List<CachedItem> getHomeownerDemands() {
    return CachedItem.decodeList(_prefs.getString(_keyHomeownerDemands));
  }

  Future<void> setHomeownerBookings(List<CachedItem> items) async {
    await _prefs.setString(_keyHomeownerBookings, CachedItem.encodeList(items));
  }

  List<CachedItem> getHomeownerBookings() {
    return CachedItem.decodeList(_prefs.getString(_keyHomeownerBookings));
  }

  Future<void> setServiceProviderDemands(List<CachedItem> items) async {
    await _prefs.setString(_keySpDemands, CachedItem.encodeList(items));
  }

  List<CachedItem> getServiceProviderDemands() {
    return CachedItem.decodeList(_prefs.getString(_keySpDemands));
  }

  Future<void> setServiceProviderBookings(List<CachedItem> items) async {
    await _prefs.setString(_keySpBookings, CachedItem.encodeList(items));
  }

  List<CachedItem> getServiceProviderBookings() {
    return CachedItem.decodeList(_prefs.getString(_keySpBookings));
  }
}
