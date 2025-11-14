import 'package:first_flutter/bloc/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_event.dart'; // 👈 importa los eventos

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Switch(
          value: state.isDarkMode,
          onChanged: (bool value) {
            context.read<ThemeBloc>().add(ToggleTheme()); // 👈 evento correcto
          },
          activeColor: const Color.fromRGBO(237, 88, 33, 1),
        );
      },
    );
  }
}
