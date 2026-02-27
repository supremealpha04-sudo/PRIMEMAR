import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const String _themeKey = 'app_theme';
  
  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey);
    
    if (themeString != null) {
      state = ThemeMode.values.firstWhere(
        (e) => e.name == themeString,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }

  Future<void> setThemeFromString(String theme) async {
    switch (theme) {
      case 'light':
        await setTheme(ThemeMode.light);
        break;
      case 'dark':
        await setTheme(ThemeMode.dark);
        break;
      default:
        await setTheme(ThemeMode.system);
    }
  }

  ThemeData getThemeData(BuildContext context) {
    switch (state) {
      case ThemeMode.light:
        return getLightTheme();
      case ThemeMode.dark:
        return getDarkTheme();
      case ThemeMode.system:
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark
            ? getDarkTheme()
            : getLightTheme();
    }
  }
}
