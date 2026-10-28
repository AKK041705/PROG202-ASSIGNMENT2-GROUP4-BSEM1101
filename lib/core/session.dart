import '../models/models.dart';
import '../state/app_state.dart';
import 'app_preferences.dart';

/// Small helpers that run when someone logs in or out.
class Session {
  Session._();

  /// Shows prices in the user's own currency (visitors from overseas).
  static void afterLogin(AppUser user) {
    AppPreferences.instance.setCurrency(user.currency);
  }

  static void logout() {
    AppState.instance.logout();
    AppPreferences.instance.setCurrency('NLe');
  }
}
