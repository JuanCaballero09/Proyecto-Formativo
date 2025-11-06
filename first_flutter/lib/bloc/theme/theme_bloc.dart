import 'package:flutter_bloc/flutter_bloc.dart';

enum ThemeEvent { toggleTheme }

class ThemeState {
  final bool isDarkMode;

  ThemeState({required this.isDarkMode});
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(isDarkMode: false)) {
    on<ThemeEvent>((event, emit) {
      switch (event) {
        case ThemeEvent.toggleTheme:
          emit(ThemeState(isDarkMode: !state.isDarkMode));
          break;
      }
    });
  }
}
