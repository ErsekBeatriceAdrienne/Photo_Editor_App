import 'package:flutter/material.dart';
import 'package:photo_editor_app/frontend/language_support/locale_provider.dart';
import 'package:provider/provider.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({
    super.key,
    required this.isDarkMode
  });

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    const supportedLocales = L10n.all;

    return DropdownButtonHideUnderline(
      child: DropdownButton<Locale>(
        icon: const Icon(Icons.language),

      borderRadius: BorderRadius.circular(12),
        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            provider.setLocale(newLocale);
          }
        },
        items: supportedLocales.map((locale) {
          final name = L10n.getLanguageName(locale.languageCode);
          return DropdownMenuItem(
            value: locale,
            child: Text(
              name,
              style: const TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
        isExpanded: false,
        dropdownColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
      ),
    );
  }
}