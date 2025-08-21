import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/theme_provider.dart';

class CacheProvider {
  static const _themeKey = 'themeKey';
  static const _focusKey = 'focusKey';
  static const _breakKey = 'breakKey';

  CacheProvider._privateConstructor();
  static final CacheProvider _instance = CacheProvider._privateConstructor();
  factory CacheProvider() => _instance;

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<AppThemeMode?> loadTheme() async {
    final themeIndex = _prefs?.getInt(_themeKey);
    if (themeIndex != null &&
        themeIndex >= 0 &&
        themeIndex < AppThemeMode.values.length) {
      return AppThemeMode.values[themeIndex];
    }
    return null;
  }

  Future<void> saveTheme(AppThemeMode themeMode) async {
    await _prefs!.setInt(_themeKey, themeMode.index);
  }

  Future<void> setFocus(int value) async {
    await _prefs?.setInt(_focusKey, value);
  }

  int get getFocus => _prefs?.getInt(_focusKey) ?? 25;

  Future<void> setBreak(int value) async {
    await _prefs?.setInt(_breakKey, value);
  }

  int get getBreak => _prefs?.getInt(_breakKey) ?? 5;
}
