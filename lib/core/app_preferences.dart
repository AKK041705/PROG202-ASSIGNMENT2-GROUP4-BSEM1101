import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_palette.dart';

/// User choices that apply to the whole app: dark mode, accent colour and the
/// currency shown next to prices. Kept in memory only in this stage.
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
    _applyTheme();
  }

  void setAccent(AccentOption value) {
    _accent = value;
    _applyTheme();
  }

  void setCurrency(String code) {
    _currency = code;
    notifyListeners();
    _rebuildEverything();
  }

  void _applyTheme() {
    AppColors.apply(AppPalette.build(accent: _accent, dark: _dark));
    notifyListeners();
    _rebuildEverything();
  }

  /// Colours are read from AppColors while screens build, so every screen that
  /// is already on the stack must be rebuilt after a change.
  void _rebuildEverything() {
    void rebuild(Element element) {
      element.markNeedsBuild();
      element.visitChildren(rebuild);
    }

    WidgetsBinding.instance.rootElement?.visitChildren(rebuild);
  }
}
