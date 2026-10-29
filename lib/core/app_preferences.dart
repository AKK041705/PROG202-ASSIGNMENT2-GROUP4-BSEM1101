import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import 'app_colors.dart';
import 'app_palette.dart';

/// The look of the app on this phone right now: dark mode, accent colour and the
/// currency shown beside prices.
///
/// Each user has their own settings. They are saved on the user's account when
/// changed, loaded when that user logs in, and reset when they log out, so one
/// person's theme never changes another person's.
class AppPreferences extends ChangeNotifier {
  AppPreferences._();

  static final AppPreferences instance = AppPreferences._();

  bool _dark = false;
  AccentOption _accent = AccentOption.green;
  String _currency = 'NLe';

  bool get dark => _dark;
  AccentOption get accent => _accent;

  /// 'NLe' means prices are shown in new leones only.
  String get currency => _currency;

  void setDark(bool value) {
    _dark = value;
    _saveToUser();
    _applyTheme();
  }

  void setAccent(AccentOption value) {
    _accent = value;
    _saveToUser();
    _applyTheme();
  }

  void setCurrency(String code) {
    _currency = code;
    _saveToUser();
    notifyListeners();
    _rebuildEverything();
  }

  /// Puts the signed-in user's own settings on screen.
  void loadForUser(AppUser user) {
    _dark = user.darkMode;
    _accent = AccentOption.values.firstWhere(
      (option) => option.name == user.accentName,
      orElse: () => AccentOption.green,
    );
    _currency = user.currency;
    _applyTheme();
  }

  /// Back to the plain default look (used when nobody is logged in).
  void resetForGuest() {
    _dark = false;
    _accent = AccentOption.green;
    _currency = 'NLe';
    _applyTheme();
  }

  /// "Restore defaults" in Settings: light mode, green, and the user's own currency.
  void restoreDefaults() {
    _dark = false;
    _accent = AccentOption.green;
    _currency = AppState.instance.currentUser?.homeCurrency ?? 'NLe';
    _saveToUser();
    _applyTheme();
  }

  void _saveToUser() {
    final user = AppState.instance.currentUser;
    if (user == null) return;
    user.darkMode = _dark;
    user.accentName = _accent.name;
    user.currency = _currency;
  }

  void _applyTheme() {
    AppColors.apply(AppPalette.build(accent: _accent, dark: _dark));
    notifyListeners();
    _rebuildEverything();
  }

  /// Colours are read from AppColors while screens build, so every screen that
  /// is already open must be rebuilt after a change.
  void _rebuildEverything() {
    void rebuild(Element element) {
      element.markNeedsBuild();
      element.visitChildren(rebuild);
    }

    WidgetsBinding.instance.rootElement?.visitChildren(rebuild);
  }
}
