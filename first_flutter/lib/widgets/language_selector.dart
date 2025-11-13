import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/language/language_bloc.dart';
import '../bloc/language/language_event.dart';
import '../bloc/language/language_state.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        if (state is LanguageLoaded) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade300),
              color: Theme.of(context).cardColor,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: state.locale.languageCode,
                items: const [
                  DropdownMenuItem(
                    value: 'es',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🇪🇸', style: TextStyle(fontSize: 20)),
                        SizedBox(width: 8),
                        Text('Español'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'en',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🇺🇸', style: TextStyle(fontSize: 20)),
                        SizedBox(width: 8),
                        Text('English'),
                      ],
                    ),
                  ),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    context.read<LanguageBloc>().add(
                          ChangeLanguage(languageCode: newValue),
                        );
                  }
                },
                icon: Icon(Icons.arrow_drop_down,
                    color: Theme.of(context).colorScheme.primary),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                dropdownColor: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          );
        }
        return CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary);
      },
    );
  }
}

class LanguageSelectorDialog extends StatelessWidget {
  const LanguageSelectorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We'll use generated localizations once flutter build is complete
    // For now, we'll use hardcoded strings
    const String selectLanguageText = "Seleccionar Idioma";

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.language, color: Colors.amber.shade600),
          const SizedBox(width: 12),
          Text(
            selectLanguageText,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LanguageOption(
            flag: '🇪🇸',
            language: 'Español',
            code: 'es',
          ),
          const SizedBox(height: 12),
          _LanguageOption(
            flag: '🇺🇸',
            language: 'English',
            code: 'en',
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String flag;
  final String language;
  final String code;

  const _LanguageOption({
    required this.flag,
    required this.language,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        bool isSelected = false;
        if (state is LanguageLoaded) {
          isSelected = state.locale.languageCode == code;
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              context.read<LanguageBloc>().add(
                    ChangeLanguage(languageCode: code),
                  );
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelected ? Colors.amber.shade50 : Colors.transparent,
                border: Border.all(
                  color:
                      isSelected ? Colors.amber.shade300 : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Text(flag, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      language,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? Colors.amber.shade800
                                : Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Colors.amber.shade600,
                      size: 24,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
