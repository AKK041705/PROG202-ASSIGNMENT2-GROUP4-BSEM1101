/// Names of every screen. Used with Navigator.pushNamed.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String guestFares = '/guest-fares';
  static const String placePicker = '/place-picker';

  static const String passenger = '/passenger';
  static const String driver = '/driver';
  static const String admin = '/admin';

  static const String fares = '/fares';
  static const String compare = '/compare';
  static const String requestTransport = '/request-transport';
  static const String requestDetails = '/request-details';
  static const String reportFare = '/report-fare';
  static const String myReports = '/my-reports';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String about = '/about';
  static const String settings = '/settings';

  static const String fareEdit = '/admin/fare-edit';
  static const String reviewReport = '/admin/review-report';
}
