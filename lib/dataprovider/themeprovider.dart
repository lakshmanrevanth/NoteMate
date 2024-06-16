import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier, WidgetsBindingObserver {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    WidgetsBinding.instance.addObserver(this);
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final systemBrightness = WidgetsBinding.instance.window.platformBrightness;
    final isSystemDarkMode = systemBrightness == Brightness.dark;
    _isDarkMode = prefs.getBool('isDarkMode') ?? isSystemDarkMode;
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  @override
  void didChangePlatformBrightness() {
    final systemBrightness = WidgetsBinding.instance.window.platformBrightness;
    final isSystemDarkMode = systemBrightness == Brightness.dark;
    _isDarkMode = isSystemDarkMode;
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
