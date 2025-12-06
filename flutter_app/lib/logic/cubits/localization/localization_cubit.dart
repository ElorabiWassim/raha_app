import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ra7a/data/local/preferences_service.dart';

// State
abstract class LocalizationState extends Equatable {
  final Locale locale;
  const LocalizationState(this.locale);

  @override
  List<Object> get props => [locale];
}

class LocalizationInitial extends LocalizationState {
  const LocalizationInitial(super.locale);
}

class LocalizationChanged extends LocalizationState {
  const LocalizationChanged(super.locale);
}

// Cubit
class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit({required PreferencesService preferences})
    : _preferences = preferences,
      super(LocalizationInitial(Locale(preferences.languageCode ?? 'en')));

  final PreferencesService _preferences;

  Future<void> changeLanguage(String languageCode) async {
    await _preferences.setLanguageCode(languageCode);
    emit(LocalizationChanged(Locale(languageCode)));
  }
}
