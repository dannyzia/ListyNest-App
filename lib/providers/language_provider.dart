
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String _languagePrefKey = 'language_code';

  Locale _appLocale = const Locale('en');

  Locale get appLocale => _appLocale;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languagePrefKey) ?? 'en';
    _appLocale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> changeLanguage(Locale newLocale) async {
    _appLocale = newLocale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languagePrefKey, newLocale.languageCode);
    notifyListeners();
  }
}
