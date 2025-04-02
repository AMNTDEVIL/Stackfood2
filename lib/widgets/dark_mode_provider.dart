import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkModeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // Method to set the dark mode value
  void setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    _isDarkMode = value;
    notifyListeners();
  }

  // Method to toggle dark mode (switch between true and false)
  void toggleDarkMode(bool value) {
    setDarkMode(value);
  }
}
