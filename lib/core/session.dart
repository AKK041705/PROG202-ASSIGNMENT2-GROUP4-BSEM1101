import '../models/models.dart';
import '../state/app_state.dart';
import 'app_preferences.dart';

/// Small helpers that run when someone logs in or out.
class Session {
  Session._();

  /// Loads this user's own theme and currency.
  static void afterLogin(AppUser user) {
    AppPreferences.instance.loadForUser(user);
  }

  /// Logs out and returns the screen to the default look.
  static void logout() {
    AppState.instance.logout();
    AppPreferences.instance.resetForGuest();
  }
}
