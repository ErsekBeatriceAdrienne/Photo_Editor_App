import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  void _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('languageCode');
    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  void setLocale(Locale locale) async {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
  }

  void clearLocale() async {
    _locale = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('languageCode');
  }
}

class L10n {
  static const all = [
    Locale('en'),
    Locale('hu')
    //Locale('ro'),
  ];

  static String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'hu':
        return 'Magyar';
      default:
        return code;
    }
  }
}