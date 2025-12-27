
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/cache_service.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final CacheService _cacheService;

  ThemeCubit({required CacheService cacheService})
      : _cacheService = cacheService,
        super(ThemeState(
          isDarkMode: false,
          themeData: _lightTheme,
        )) {
    _loadTheme();
  }

  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  Future<void> _loadTheme() async {
    final isDark = await _cacheService.loadDarkMode();
    emit(ThemeState(
      isDarkMode: isDark,
      themeData: isDark ? _darkTheme : _lightTheme,
    ));
  }

  Future<void> toggleTheme() async {
    final newIsDark = !state.isDarkMode;
    await _cacheService.saveDarkMode(newIsDark);
    emit(ThemeState(
      isDarkMode: newIsDark,
      themeData: newIsDark ? _darkTheme : _lightTheme,
    ));
  }

  Future<void> setDarkMode(bool isDark) async {
    await _cacheService.saveDarkMode(isDark);
    emit(ThemeState(
      isDarkMode: isDark,
      themeData: isDark ? _darkTheme : _lightTheme,
    ));
  }

  Future<void> setLightMode() async {
    await setDarkMode(false);
  }
}
