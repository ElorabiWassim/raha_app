// BONUS: Language Cubit with SharedPreferences persistence
// Add to pubspec.yaml: shared_preferences: ^2.2.2

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageState extends Equatable {
  final Locale locale;

  const LanguageState(this.locale);

  @override
  List<Object> get props => [locale];
}

class LanguageCubit extends Cubit<LanguageState> {
  static const String _languageKey = 'selected_language';

  LanguageCubit() : super(const LanguageState(Locale('en'))) {
    _loadSavedLanguage();
  }

  // Load saved language from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);
      
      if (savedLanguage != null) {
        emit(LanguageState(Locale(savedLanguage)));
      }
    } catch (e) {
      // If loading fails, use default language (English)
      emit(const LanguageState(Locale('en')));
    }
  }

  // Change language and save to SharedPreferences
  Future<void> changeLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      emit(LanguageState(Locale(languageCode)));
    } catch (e) {
      // Handle error if needed
      print('Error saving language preference: $e');
    }
  }

  void setEnglish() => changeLanguage('en');
  void setFrench() => changeLanguage('fr');
  void setArabic() => changeLanguage('ar');

  // Get current language code
  String get currentLanguageCode => state.locale.languageCode;

  // Check if specific language is selected
  bool get isEnglish => state.locale.languageCode == 'en';
  bool get isFrench => state.locale.languageCode == 'fr';
  bool get isArabic => state.locale.languageCode == 'ar';
}