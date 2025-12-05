import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  LocalizationCubit() : super(const LocalizationInitial(Locale('en')));

  void changeLanguage(String languageCode) {
    emit(LocalizationChanged(Locale(languageCode)));
  }
}
