import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme/theme_bloc.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return SwitchListTile(
          title: Text(
            state.isDarkMode ? 'Tema Oscuro' : 'Tema Claro',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          secondary: Icon(
            state.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: Theme.of(context).primaryColor,
          ),
          value: state.isDarkMode,
          onChanged: (bool value) {
            context.read<ThemeBloc>().add(ThemeEvent.toggleTheme);
          },
        );
      },
    );
  }
}
