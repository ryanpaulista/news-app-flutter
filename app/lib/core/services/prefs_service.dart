import 'package:shared_preferences/shared_preferences.dart';

// Preferências não-sensíveis (tema, última busca). Nunca guardar token aqui.
class PrefsService {
  static const _darkThemeKey = 'dark_theme';
  static const _lastQueryKey = 'last_query';

  Future<bool> isDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkThemeKey) ?? false;
  }

  Future<void> setDarkTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkThemeKey, value);
  }

  Future<String?> lastQuery() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastQueryKey);
  }

  Future<void> setLastQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastQueryKey, query);
  }
}

final prefsService = PrefsService();
