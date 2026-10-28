import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  /// Builds the Flutter theme from the current palette.
  static ThemeData build() {
    final p = AppColors.palette;
    final scheme = p.isDark
        ? ColorScheme.dark(
            primary: p.accent,
            onPrimary: Colors.white,
            secondary: p.info,
            onSecondary: Colors.white,
            error: p.red,
            onError: Colors.white,
            surface: p.surface,
            onSurface: p.textPrimary,
          )
        : ColorScheme.light(
            primary: p.accent,
            onPrimary: Colors.white,
            secondary: p.info,
            onSecondary: Colors.white,
            error: p.red,
            onError: Colors.white,
            surface: p.surface,
            onSurface: p.textPrimary,
          );
    final base = ThemeData(
      useMaterial3: true,
      brightness: p.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      dividerColor: p.border,
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: p.textPrimary,
        displayColor: p.textPrimary,
      ),
    );
  }
}
