import '../models/models.dart';
import 'place_data.dart';

/// All fare rules from the Assignment 1 Dart prototype, written for the app.
class FareService {
  FareService._();

  /// Modes shown on the fare and compare screens.
  static const List<String> fareModes = [
    'Okada',
    'Kekeh',
    'Taxi (shared)',
    'Taxi (private hire)',
    'Poda-poda',
    'Bus',
  ];

  /// Seats in each vehicle type (assumed). These are the request types.
  static const Map<String, int> seatCapacity = {
    'Okada': 1,
    'Kekeh': 3,
    'Taxi (shared)': 4,
    'Taxi (private hire)': 4,
    'Private vehicle': 6,
    'Poda-poda': 12,
    'Bus': 30,
  };

  /// Simulated pricing rule: [base fare in NLe, rate per km in NLe].
  static const Map<String, List<double>> _rates = {
    'Okada': [5.0, 1.6],
    'Kekeh': [5.0, 1.3],
    'Taxi (shared)': [5.0, 0.8],
    'Taxi (private hire)': [20.0, 2.5],
    'Private vehicle': [30.0, 3.0],
    'Poda-poda': [3.0, 0.45],
    'Bus': [5.0, 0.62],
  };

  static const Map<String, String> _fareTypes = {
    'Okada': 'Per passenger',
    'Kekeh': 'Per passenger',
    'Taxi (shared)': 'Shared, per passenger',
    'Taxi (private hire)': 'Private hire, per trip',
    'Private vehicle': 'Private hire, per trip',
    'Poda-poda': 'Per passenger',
    'Bus': 'Per passenger',
  };

  /// Modes where every reserved seat is paid for (others are per trip).
  static const List<String> perPassengerModes = [
    'Okada',
    'Kekeh',
    'Taxi (shared)',
    'Poda-poda',
    'Bus',
  ];

  /// What a driver can register as.
  static const List<String> driverTypes = [
    'Okada',
    'Kekeh',
    'Taxi',
    'Private vehicle',
    'Poda-poda',
    'Bus',
  ];

  static const List<String> adminFareModes = ['Okada', 'Kekeh', 'Poda-poda', 'Bus'];

  static final Map<String, Place> _byName = {
    for (final place in kPlaces) place.name: place,
  };

  static List<String> get placeNames => kPlaces.map((p) => p.name).toList();

  static String driverTypeFor(String mode) =>
      mode.startsWith('Taxi') ? 'Taxi' : mode;

  static bool isPerPassenger(String mode) => perPassengerModes.contains(mode);

  static Place? placeByName(String? name) => name == null ? null : _byName[name];

  static String corridorOf(Place p) =>
      p.isWesternArea ? 'Western' : p.area;

  /// Simulated road distance between two places.
  static int distanceKm(String a, String b) {
    final pa = _byName[a]!;
    final pb = _byName[b]!;
    if (corridorOf(pa) == corridorOf(pb)) return (pa.km - pb.km).abs();
    return pa.km + pb.km; // different roads: travel via Freetown
  }

  static String? unavailableReason(String mode, String a, String b) {
    final pa = _byName[a]!;
    final pb = _byName[b]!;
    final km = distanceKm(a, b);
    if (mode == 'Kekeh' && !(pa.isWesternArea && pb.isWesternArea)) {
      return 'Kekeh do not run in the provinces';
    }
    if ((mode == 'Okada' || mode == 'Kekeh') && km > 60) {
      return 'Not typically available for this distance';
    }
    if (mode == 'Bus' && km < 20) {
      return 'No scheduled bus service assumed for this short distance';
    }
    return null;
  }

  static Tariff? _routeTariff(List<Tariff> tariffs, String mode, String a, String b) {
    for (final t in tariffs) {
      if (t.mode == mode && t.matches(a, b)) return t;
    }
    return null;
  }

  static Tariff? _publishedTariff(List<Tariff> tariffs, String mode, String a, String b) {
    final route = _routeTariff(tariffs, mode, a, b);
    if (route != null) return route;
    if (_byName[a]!.area == 'City' && _byName[b]!.area == 'City') {
      for (final t in tariffs) {
        if (t.mode == mode && t.isFlat) return t;
      }
    }
    return null;
  }

  /// Finds the fare: published fare first, otherwise a simulated estimate.
  static FareQuote quote(List<Tariff> tariffs, String mode, String a, String b) {
    final published = _publishedTariff(tariffs, mode, a, b);
    if (published != null) {
      return FareQuote(
        amount: published.fare,
        type: published.type,
        source: published.source,
        flat: published.isFlat,
      );
    }
    final reason = unavailableReason(mode, a, b);
    if (reason != null) return FareQuote.unavailable(reason);
    final rule = _rates[mode]!;
    final raw = rule[0] + rule[1] * distanceKm(a, b);
    final amount = (raw * 2).roundToDouble() / 2;
    return FareQuote(
      amount: amount,
      type: _fareTypes[mode] ?? 'Per passenger',
      source: 'Simulated estimate',
    );
  }

  static String money(double value) => 'NLe ${value.toStringAsFixed(1)}';

  /// One-line text for a quote, e.g. "NLe 12.0".
  static String amountText(FareQuote q) {
    if (!q.isAvailable) return 'Not available';
    if (q.amount == null) return "Rider's discretion";
    return money(q.amount!);
  }

  /// The total in NLe for a request, or null when the fare is not fixed.
  static double? requestTotal(FareQuote q, String mode, int people, int freeSeats) {
    if (!q.isAvailable || q.amount == null) return null;
    if (isPerPassenger(mode)) return q.amount! * (people + freeSeats);
    return q.amount;
  }

  /// Total estimated fare for a request. Every reserved seat is paid for in
  /// per-passenger modes; private hire is one fare for the whole trip.
  static String requestFareText(
    FareQuote q,
    String mode,
    int people,
    int freeSeats,
  ) {
    if (!q.isAvailable) return 'No fare available';
    if (q.amount == null) return "Rider's discretion - agree with the driver";
    if (isPerPassenger(mode)) {
      final seats = people + freeSeats;
      final total = q.amount! * seats;
      return '${money(total)} for $seats seat(s) (${money(q.amount!)} per seat)';
    }
    return '${money(q.amount!)} for the whole trip';
  }
}
