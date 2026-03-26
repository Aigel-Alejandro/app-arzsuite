import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global_providers.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;
  static const _themeModeKey = 'app_theme_mode';

  ThemeNotifier(this._prefs) : super(_loadThemeMode(_prefs));

  static ThemeMode _loadThemeMode(SharedPreferences prefs) {
    final themeString = prefs.getString(_themeModeKey);
    if (themeString == 'light') return ThemeMode.light;
    if (themeString == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else if (state == ThemeMode.dark) {
      setThemeMode(ThemeMode.system);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    String modeString;
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      case ThemeMode.system:
        modeString = 'system';
        break;
    }
    _prefs.setString(_themeModeKey, modeString);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});
