import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to expose the ThemeNotifier.
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

/// Manages the theme state (light/dark mode).
class ThemeNotifier extends StateNotifier<ThemeMode> {
  // The default theme is light.
  ThemeNotifier() : super(ThemeMode.light);

  /// Toggles the theme between light and dark mode.
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}