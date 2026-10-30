import 'package:flutter/foundation.dart';

import '../data/fare_service.dart';
import '../services/currency_service.dart';
import '../services/phone_service.dart';
import '../data/tariff_data.dart';
import '../models/models.dart';

/// Holds all app data in memory and the actions that change it.
/// There is no database in this stage: everything is lost when the app closes.
/// Screens listen to this object and rebuild when it changes.
class AppState extends ChangeNotifier {
  AppState._() {
    _seedUsers();
    _seedDemoData();
  }

  static final AppState instance = AppState._();

  final List<AppUser> users = [];
  final List<Tariff> tariffs = TariffData.seed();
  final List<TransportRequest> requests = [];
  final List<FareReport> reports = [];
  final List<AppNotification> notifications = [];

  AppUser? currentUser;

  void _seedUsers() {
    AppUser driver(String user, String name, String type, String vehicle, String plate) {
      return AppUser(
        username: user,
        password: '1234',
        role: UserRole.driver,
        name: name,
        phone: 'Demo',
        driverType: type,
        vehicle: vehicle,
        plate: plate,
      );
    }

    users.addAll([
      AppUser(
        username: 'admin',
        password: 'admin123',
        role: UserRole.administrator,
        name: 'System Administrator',
        phone: 'N/A',
      ),
      driver('rider1', 'Sample Rider A', 'Okada', 'Motorbike', 'SL-DEMO-01'),
      driver('kekeh1', 'Sample Rider B', 'Kekeh', 'Tricycle', 'SL-DEMO-02'),
      driver('taxi1', 'Sample Driver C', 'Taxi', 'Saloon car', 'SL-DEMO-03'),
      driver('taxi2', 'Sample Driver D', 'Taxi', 'Saloon car', 'SL-DEMO-04'),
      driver('van1', 'Sample Driver E', 'Private vehicle', 'Minivan', 'SL-DEMO-05'),
      driver('poda1', 'Sample Driver F', 'Poda-poda', 'Minibus', 'SL-DEMO-06'),
      driver('bus1', 'Sample Driver G', 'Bus', 'Coach', 'SL-DEMO-07'),
    ]);
  }

  /// Fictional sample data so every screen has something to show.
  void _seedDemoData() {
    AppUser passenger(String user, String name, String phone) => AppUser(
          username: user,
          password: '1234',
          role: UserRole.passenger,
          name: name,
          phone: phone,
        );

    users.addAll([
      passenger('amina', 'Amina Kamara', '+23276123456'),
      passenger('mohamed', 'Mohamed Sesay', '+23277234567'),
      AppUser(
        username: 'sarah',
        password: '1234',
        role: UserRole.passenger,
        name: 'Sarah Johnson (visitor)',
        phone: '+447700900123',
        currency: 'GBP',
        country: 'United Kingdom',
      ),
      // A driver still waiting for the administrator to verify.
      AppUser(
        username: 'kekeh2',
        password: '1234',
        role: UserRole.driver,
        name: 'Sample Rider H',
        phone: 'Demo',
        driverType: 'Kekeh',
        vehicle: 'Tricycle',
        plate: 'SL-DEMO-08',
        verified: false,
      ),
    ]);

    TransportRequest demoRequest({
      required String passenger,
      required String pickup,
      required String destination,
      required String mode,
      required int people,
      int freeSeats = 0,
      required RequestStatus status,
      String? driver,
      String payCurrency = 'NLe',
    }) {
      final q = quote(mode, pickup, destination);
      final total = FareService.requestTotal(q, mode, people, freeSeats);
      final request = TransportRequest(
        id: 'REQ-${requests.length + 1}',
        passenger: passenger,
        pickup: pickup,
        destination: destination,
        mode: mode,
        people: people,
        freeSeats: freeSeats,
        fareText: FareService.requestFareText(q, mode, people, freeSeats),
        payCurrency: payCurrency,
        payAmount: total == null ? null : CurrencyService.amountIn(total, payCurrency),
        payRate: CurrencyService.rateFor(payCurrency),
      );
      request.status = status;
      request.driver = driver;
      requests.add(request);
      return request;
    }

    demoRequest(
      passenger: 'amina',
      pickup: 'Lumley',
      destination: 'Wilberforce',
      mode: 'Kekeh',
      people: 2,
      freeSeats: 1,
      status: RequestStatus.confirmed,
      driver: 'kekeh1',
    );
    demoRequest(
      passenger: 'mohamed',
      pickup: 'Freetown',
      destination: 'Bo',
      mode: 'Bus',
      people: 3,
      status: RequestStatus.pending,
    );
    demoRequest(
      passenger: 'amina',
      pickup: 'Waterloo',
      destination: 'Bombay Street',
      mode: 'Poda-poda',
      people: 1,
      status: RequestStatus.completed,
      driver: 'poda1',
    );
    demoRequest(
      passenger: 'mohamed',
      pickup: 'Freetown',
      destination: 'Makeni',
      mode: 'Taxi (private hire)',
      people: 2,
      status: RequestStatus.awaitingPassenger,
      driver: 'taxi1',
    );

    demoRequest(
      passenger: 'sarah',
      pickup: 'Freetown',
      destination: 'Waterloo',
      mode: 'Taxi (shared)',
      people: 2,
      status: RequestStatus.pending,
      payCurrency: 'GBP',
    );

    final first = FareReport(
      id: 'RPT-1',
      passenger: 'amina',
      route: 'Lumley -> Wilberforce',
      mode: 'Okada',
      reported: 10,
      note: 'The rider asked for more than the posted pole-to-pole fare.',
      systemFare: 'NLe 7.0 [Official price list]',
    );
    final second = FareReport(
      id: 'RPT-2',
      passenger: 'mohamed',
      route: 'Waterloo -> Bombay Street',
      mode: 'Poda-poda',
      reported: 20,
      note: 'The conductor asked for a higher fare.',
      systemFare: 'NLe 14.7 [Published sample (news)]',
    );
    second.status = ReportStatus.closed;
    second.response = 'Checked against the current fare list. Thank you for reporting.';
    reports.addAll([first, second]);

    notify('admin', 'New fare issue report RPT-1 (Lumley -> Wilberforce, Okada).');
    notify('admin', 'New driver registered: Sample Rider H (kekeh2). Verification needed.');
    notify('amina', 'REQ-3: your trip was marked as completed.');
    notify('mohamed',
        'REQ-4: Sample Driver C accepted your request. Open it to accept or reject this driver.');
    notify('mohamed', 'Report RPT-2 is now: Closed. ${second.response}');
    notify('kekeh1', 'REQ-1: the passenger accepted you. Trip confirmed.');
  }

  // ---------------------------------------------------------------- users

  AppUser? findUser(String username) {
    for (final u in users) {
      if (u.username == username) return u;
    }
    return null;
  }

  bool usernameTaken(String username) =>
      findUser(username.trim().toLowerCase()) != null;

  /// Returns the user when the details are right, otherwise null.
  AppUser? login(String username, String password) {
    final user = findUser(username.trim().toLowerCase());
    if (user != null && user.password == password) {
      currentUser = user;
      notifyListeners();
      return user;
    }
    return null;
  }

  /// Saves the currency the signed-in user wants to see beside prices.
  void setUserCurrency(String code) {
    currentUser?.currency = code;
    notifyListeners();
  }

  void logout() {
    currentUser = null;
    notifyListeners();
  }

  AppUser register({
    required UserRole role,
    required String name,
    required String username,
    required String password,
    required String phone,
    String? driverType,
    String? vehicle,
    String? plate,
  }) {
    final isDriver = role == UserRole.driver;
    final phoneInfo = PhoneService.parse(phone);
    final country = phoneInfo.country;
    final user = AppUser(
      username: username.trim().toLowerCase(),
      password: password,
      role: role,
      name: name.trim(),
      phone: phoneInfo.e164 ?? phone.trim(),
      driverType: driverType,
      vehicle: vehicle?.trim(),
      plate: plate?.trim(),
      verified: !isDriver,
      currency: country?.currency ?? 'USD',
      country: country?.name ?? 'Overseas',
    );
    users.add(user);
    if (isDriver) {
      notifyRole(
        UserRole.administrator,
        'New driver registered: ${user.name} (${user.username}). Verification needed.',
      );
    }
    notifyListeners();
    return user;
  }

  int countVerifiedDrivers(String driverType) {
    return users
        .where((u) =>
            u.role == UserRole.driver &&
            u.verified &&
            u.driverType == driverType)
        .length;
  }

  List<AppUser> get drivers =>
      users.where((u) => u.role == UserRole.driver).toList();

  void verifyDriver(AppUser driver) {
    driver.verified = true;
    notify(driver.username, 'Your driver account has been verified. You can now receive requests.');
    notifyListeners();
  }

  // -------------------------------------------------------- notifications

  void notify(String to, String text) {
    notifications.add(AppNotification(to: to, text: text));
  }

  void notifyRole(UserRole role, String text) {
    for (final u in users) {
      if (u.role == role) notify(u.username, text);
    }
  }

  List<AppNotification> notificationsFor(String username) {
    return notifications.where((n) => n.to == username).toList().reversed.toList();
  }

  int unreadCount(String username) {
    return notifications.where((n) => n.to == username && !n.read).length;
  }

  void markAllRead(String username) {
    var changed = false;
    for (final n in notifications) {
      if (n.to == username && !n.read) {
        n.read = true;
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }

  /// Used by pull-to-refresh: tells every screen to rebuild with the latest data.
  void refresh() => notifyListeners();

  // ----------------------------------------------------------------- fares

  FareQuote quote(String mode, String a, String b) =>
      FareService.quote(tariffs, mode, a, b);

  List<Tariff> tariffsForMode(String mode) =>
      tariffs.where((t) => t.mode == mode).toList();

  /// Adds a route fare or updates the existing one.
  void upsertTariff({
    required String mode,
    required String from,
    required String to,
    required double fare,
    Tariff? existing,
  }) {
    Tariff? target = existing;
    if (target == null) {
      for (final t in tariffs) {
        if (t.mode == mode && t.matches(from, to)) target = t;
      }
    }
    if (target != null) {
      target.fare = fare;
      target.source = 'Administrator update';
    } else {
      tariffs.add(Tariff(
        mode: mode,
        from: from,
        to: to,
        fare: fare,
        source: 'Administrator update',
      ));
    }
    notifyRole(UserRole.passenger,
        'Fare update: $mode $from <-> $to is now ${FareService.money(fare)}.');
    notifyListeners();
  }

  void updateFlatFare(Tariff flat, double fare) {
    flat.fare = fare;
    flat.source = 'Administrator update';
    notifyRole(UserRole.passenger,
        'Fare update: ${flat.mode} pole-to-pole fare is now ${FareService.money(fare)}.');
    notifyListeners();
  }

  // -------------------------------------------------------------- requests

  TransportRequest? requestById(String id) {
    for (final r in requests) {
      if (r.id == id) return r;
    }
    return null;
  }

  TransportRequest createRequest({
    required String pickup,
    required String destination,
    required String mode,
    required int people,
    required int freeSeats,
    required String fareText,
    String note = '',
    String payCurrency = 'NLe',
    double? payAmount,
  }) {
    final request = TransportRequest(
      id: 'REQ-${requests.length + 1}',
      passenger: currentUser!.username,
      pickup: pickup,
      destination: destination,
      mode: mode,
      people: people,
      freeSeats: freeSeats,
      fareText: fareText,
      note: note,
      payCurrency: payCurrency,
      payAmount: payAmount,
      payRate: CurrencyService.rateFor(payCurrency),
    );
    requests.add(request);
    notifyListeners();
    return request;
  }

  List<TransportRequest> requestsOfPassenger(String username) =>
      requests.where((r) => r.passenger == username).toList().reversed.toList();

  /// Pending requests a verified driver of the matching type can see.
  List<TransportRequest> incomingFor(AppUser driver) {
    if (!driver.verified) return [];
    return requests
        .where((r) =>
            r.status == RequestStatus.pending &&
            FareService.driverTypeFor(r.mode) == driver.driverType &&
            !r.declinedDrivers.contains(driver.username))
        .toList()
        .reversed
        .toList();
  }

  List<TransportRequest> tripsOfDriver(String username) =>
      requests.where((r) => r.driver == username).toList().reversed.toList();

  void driverAccept(TransportRequest r, AppUser driver) {
    r.driver = driver.username;
    r.status = RequestStatus.awaitingPassenger;
    notify(r.passenger,
        '${r.id}: ${driver.name} accepted your request. Open it to accept or reject this driver.');
    notifyListeners();
  }

  void driverDecline(TransportRequest r, AppUser driver) {
    r.declinedDrivers.add(driver.username);
    notifyListeners();
  }

  void passengerAcceptDriver(TransportRequest r) {
    r.status = RequestStatus.confirmed;
    if (r.driver != null) {
      notify(r.driver!, '${r.id}: the passenger accepted you. Trip confirmed.');
    }
    notifyListeners();
  }

  void passengerRejectDriver(TransportRequest r) {
    final driverName = r.driver;
    if (driverName != null) {
      r.declinedDrivers.add(driverName);
      notify(driverName,
          '${r.id}: the passenger rejected you. The request is open to other drivers.');
    }
    r.driver = null;
    r.status = RequestStatus.pending;
    notifyListeners();
  }

  void cancelRequest(TransportRequest r) {
    r.status = RequestStatus.cancelled;
    if (r.driver != null) {
      notify(r.driver!, '${r.id}: the passenger cancelled the request.');
    }
    notifyListeners();
  }

  void completeTrip(TransportRequest r) {
    r.status = RequestStatus.completed;
    notify(r.passenger, '${r.id}: your trip was marked as completed.');
    notifyListeners();
  }

  // --------------------------------------------------------------- reports

  FareReport submitReport({
    required String from,
    required String to,
    required String mode,
    required double reported,
    required String note,
    required String systemFare,
  }) {
    final report = FareReport(
      id: 'RPT-${reports.length + 1}',
      passenger: currentUser!.username,
      route: '$from -> $to',
      mode: mode,
      reported: reported,
      note: note.trim().isEmpty ? 'No description' : note.trim(),
      systemFare: systemFare,
    );
    reports.add(report);
    notifyRole(UserRole.administrator,
        'New fare issue report ${report.id} (${report.route}, $mode).');
    notifyListeners();
    return report;
  }

  List<FareReport> reportsOfPassenger(String username) =>
      reports.where((r) => r.passenger == username).toList().reversed.toList();

  FareReport? reportById(String id) {
    for (final r in reports) {
      if (r.id == id) return r;
    }
    return null;
  }

  void reviewReport(FareReport report, ReportStatus status, String message) {
    report.status = status;
    report.response = message.trim();
    notify(report.passenger,
        'Report ${report.id} is now: ${status.label}. ${report.response}'.trim());
    notifyListeners();
  }
}
