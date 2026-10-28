import 'package:flutter/material.dart';

import 'app_palette.dart';

/// The colours used on screen. They come from the current palette, so changing
/// the theme in Settings changes every screen. Use these names everywhere
/// instead of writing colours directly, so colours never clash.
class AppColors {
  AppColors._();

  static AppPalette _palette = AppPalette.build(accent: AccentOption.green, dark: false);

  static AppPalette get palette => _palette;

  static void apply(AppPalette palette) {
    _palette = palette;
  }

  // Brand (follows the chosen accent colour)
  static Color get green => _palette.accent;
  static Color get greenDark => _palette.accentDark;
  static Color get greenTint => _palette.accentTint;

  // Fixed meaning colours (do not change with the accent)
  static Color get success => _palette.success;
  static Color get successTint => _palette.successTint;
  static Color get info => _palette.info;
  static Color get infoTint => _palette.infoTint;
  static Color get blue => _palette.info;
  static Color get blueTint => _palette.infoTint;
  static Color get amber => _palette.amber;
  static Color get amberTint => _palette.amberTint;
  static Color get red => _palette.red;
  static Color get redTint => _palette.redTint;

  // Neutrals
  static Color get background => _palette.background;
  static Color get surface => _palette.surface;
  static Color get border => _palette.border;
  static Color get textPrimary => _palette.textPrimary;
  static Color get textSecondary => _palette.textSecondary;
}
