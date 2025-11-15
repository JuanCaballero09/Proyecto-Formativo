import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ToggleTheme>(_onToggleTheme);
    on<LoadTheme>(_onLoadTheme);

    // Cargar el tema guardado al iniciar
    add(LoadTheme());
  }

  Future<void> _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    final newTheme = !state.isDarkMode;
    emit(state.copyWith(isDarkMode: newTheme));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newTheme);
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool('isDarkMode') ?? false;
    emit(state.copyWith(isDarkMode: saved));
  }
}
