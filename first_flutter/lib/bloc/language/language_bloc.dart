import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  static const String _languageCodeKey = 'language_code';

  LanguageBloc() : super(LanguageLoading()) {
    on<LoadLanguage>(_onLoadLanguage);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  void _onLoadLanguage(LoadLanguage event, Emitter<LanguageState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageCodeKey) ?? 'es'; // Default to Spanish
      
      emit(LanguageLoaded(locale: Locale(languageCode)));
    } catch (e) {
      emit(const LanguageError(message: 'Failed to load language preference'));
    }
  }

  void _onChangeLanguage(ChangeLanguage event, Emitter<LanguageState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageCodeKey, event.languageCode);
      
      emit(LanguageLoaded(locale: Locale(event.languageCode)));
    } catch (e) {
      emit(const LanguageError(message: 'Failed to change language'));
    }
  }
}
