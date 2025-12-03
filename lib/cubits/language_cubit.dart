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

 
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);
      
      if (savedLanguage != null) {
        emit(LanguageState(Locale(savedLanguage)));
      }
    } catch (e) {
     
      emit(const LanguageState(Locale('en')));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      emit(LanguageState(Locale(languageCode)));
    } catch (e) {
      
      print('Error saving language preference: $e');
    }
  }

  void setEnglish() => changeLanguage('en');
  void setFrench() => changeLanguage('fr');
  void setArabic() => changeLanguage('ar');


  String get currentLanguageCode => state.locale.languageCode;

  
  bool get isEnglish => state.locale.languageCode == 'en';
  bool get isFrench => state.locale.languageCode == 'fr';
  bool get isArabic => state.locale.languageCode == 'ar';
}