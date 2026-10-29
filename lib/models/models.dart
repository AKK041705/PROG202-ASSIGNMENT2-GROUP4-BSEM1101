/// Plain data classes used across the app (the "entities" from Assignment 1).

enum UserRole { passenger, driver, administrator }

extension UserRoleText on UserRole {
  String get label {
    switch (this) {
      case UserRole.passenger:
        return 'Passenger';
      case UserRole.driver:
        return 'Driver';
      case UserRole.administrator:
        return 'Administrator';
    }
  }
}

enum RequestStatus { pending, awaitingPassenger, confirmed, completed, cancelled }

extension RequestStatusText on RequestStatus {
  String get label {
    switch (this) {
      case RequestStatus.pending:
        return 'Pending';
      case RequestStatus.awaitingPassenger:
        return 'Awaiting Passenger';
      case RequestStatus.confirmed:
        return 'Confirmed';
      case RequestStatus.completed:
        return 'Completed';
      case RequestStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isActive =>
      this == RequestStatus.pending ||
      this == RequestStatus.awaitingPassenger ||
      this == RequestStatus.confirmed;
}

enum ReportStatus { pendingReview, underReview, closed }

extension ReportStatusText on ReportStatus {
  String get label {
    switch (this) {
      case ReportStatus.pendingReview:
        return 'Pending Review';
      case ReportStatus.underReview:
        return 'Under Review';
      case ReportStatus.closed:
        return 'Closed';
    }
  }
}

class AppUser {
  AppUser({
    required this.username,
    required this.password,
    required this.role,
    required this.name,
    required this.phone,
    this.driverType,
    this.vehicle,
    this.plate,
    this.verified = true,
    String currency = 'NLe',
    this.country = 'Sierra Leone',
    this.darkMode = false,
    this.accentName = 'green',
  })  : currency = currency,
        homeCurrency = currency;

  final String username;
  final String password;
  final UserRole role;
  final String name;
  final String phone;
  final String? driverType;
  final String? vehicle;
  final String? plate;
  bool verified;

  /// Currency shown beside prices ('NLe' means leones only).
  String currency;

  /// The currency this user started with (used by Restore defaults).
  final String homeCurrency;

  /// This user's own look: dark mode and accent colour (an AccentOption name).
  bool darkMode;
  String accentName;

  /// Country found from the phone number.
  final String country;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

/// One fare record. from == '*' means a flat "pole to pole" fare.
class Tariff {
  Tariff({
    required this.mode,
    required this.from,
    required this.to,
    this.fare,
    this.type = 'Per passenger',
    this.source = 'Official price list',
  });

  final String mode;
  final String from;
  final String to;
  double? fare;
  String type;
  String source;

  bool get isFlat => from == '*';

  bool matches(String a, String b) {
    if (isFlat) return false;
    return (from == a && to == b) || (from == b && to == a);
  }
}

/// The result of asking "what is the fare for this mode on this route?".
class FareQuote {
  const FareQuote({
    this.amount,
    required this.type,
    required this.source,
    this.flat = false,
    this.unavailableReason,
  });

  const FareQuote.unavailable(String reason)
      : amount = null,
        type = '',
        source = '',
        flat = false,
        unavailableReason = reason;

  final double? amount;
  final String type;
  final String source;
  final bool flat;
  final String? unavailableReason;

  bool get isAvailable => unavailableReason == null;
  bool get isNegotiated => isAvailable && amount == null;
  bool get isSimulated => source == 'Simulated estimate';
}

class TransportRequest {
  TransportRequest({
    required this.id,
    required this.passenger,
    required this.pickup,
    required this.destination,
    required this.mode,
    required this.people,
    required this.freeSeats,
    required this.fareText,
    this.note = '',
  });

  final String id;
  final String passenger;
  final String pickup;
  final String destination;
  final String mode;
  final int people;
  final int freeSeats;
  final String fareText;
  final String note;
  RequestStatus status = RequestStatus.pending;
  String? driver;
  final List<String> declinedDrivers = [];
}

class FareReport {
  FareReport({
    required this.id,
    required this.passenger,
    required this.route,
    required this.mode,
    required this.reported,
    required this.note,
    required this.systemFare,
  });

  final String id;
  final String passenger;
  final String route;
  final String mode;
  final double reported;
  final String note;
  final String systemFare;
  ReportStatus status = ReportStatus.pendingReview;
  String response = '';
}

class AppNotification {
  AppNotification({required this.to, required this.text})
      : time = DateTime.now();

  final String to;
  final String text;
  final DateTime time;
  bool read = false;
}
