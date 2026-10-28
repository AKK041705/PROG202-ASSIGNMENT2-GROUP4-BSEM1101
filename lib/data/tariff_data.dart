import '../models/models.dart';

/// Starting fare records. Fares come from the price lists supplied for the
/// project; poda-poda fares are samples from news reports.
class TariffData {
  TariffData._();

  static const String _news = 'Published sample (news)';

  static List<Tariff> seed() {
    Tariff kekeh(String a, String b, double? fare, {String? type}) => Tariff(
          mode: 'Kekeh',
          from: a,
          to: b,
          fare: fare,
          type: type ?? 'Per passenger',
        );
    Tariff bus(String a, String b, double fare, {String? type}) => Tariff(
          mode: 'Bus',
          from: a,
          to: b,
          fare: fare,
          type: type ?? 'Per passenger',
        );

    return [
      // Pole-to-pole (new price NLe 7, old price NLe 6.1)
      Tariff(mode: 'Okada', from: '*', to: '*', fare: 7.0, type: 'Flat pole-to-pole'),
      Tariff(mode: 'Kekeh', from: '*', to: '*', fare: 7.0, type: 'Flat pole-to-pole'),

      // Kekeh routes (Western Area only)
      kekeh('Lumley', 'Wilberforce', 12),
      kekeh('Wilberforce', 'Imatt', 12),
      kekeh('Wilberforce', 'Regent', 20),
      kekeh('Wilberforce', 'Douzak', 12),
      kekeh('Douzak', 'Up-gun', 12),
      kekeh('Lumley', 'PZ', 30),
      kekeh('Lumley', 'Douzak', 23),
      kekeh('Lumley', 'Model', 30),
      kekeh('Lumley', 'Congo Cross', 15),
      kekeh('Lumley', 'Aberdeen', 12),
      kekeh('Lumley', 'Bah Junction', 12),
      kekeh('Lumley', 'Levumaa Beach', 12),
      kekeh('Lumley', 'Funkia Junction', 12),
      kekeh('Lumley', 'Femi Turner', 15),
      kekeh('Lumley', 'College Junction', 15),
      kekeh('Lumley', 'Ogu Farm Junction', 18),
      kekeh('Lumley', 'Laka Junction', 18),
      kekeh('Lumley', 'Hamilton Junction', 23),
      kekeh('Lumley', 'Mambo Junction', 28),
      kekeh('Up-gun', 'PZ', 15),
      kekeh('PZ', 'Model', 15),
      kekeh('Lumley', 'Wilkinson Road', 12),
      kekeh('Lumley', 'Aberdeen Road Junction', 12),
      kekeh('Wilberforce', 'Jui', 35),
      kekeh('Lumley', 'Jui', null, type: "At the rider's discretion"),
      kekeh('Regent', 'Jui', 18),
      kekeh('Up-gun', 'Jui', 33),
      kekeh('Up-gun', 'Calaba Town', 20),
      kekeh('Calaba Town', 'Jui', 12),
      kekeh('Jui', 'Tombo Junction', 20),
      kekeh('Jui', 'Waterloo 55', 25),
      kekeh('Tombo Junction', 'Waterloo 55', 7),
      kekeh('Waterloo 55', '4 Mile', 12),
      kekeh('Waterloo 55', 'Crossing', 18),
      kekeh('Waterloo 55', 'Brama', 22),
      kekeh('Waterloo 55', 'Songo', 30),
      kekeh('Tombo Junction', 'Kerry Town', 12),
      kekeh('Tombo Junction', 'Tombo', 25),
      kekeh('Tombo Junction', 'Rokel', 12),
      kekeh('Tombo Junction', 'Devil Hole', 10),
      kekeh('Tombo Junction', 'Fire Force', 10),
      kekeh('Jui', 'Yams Farm', 10),

      // Provincial buses (fares at NLe 45.00 per litre)
      bus('Freetown', 'Kailahun', 394.9),
      bus('Freetown', 'Kono', 300.2),
      bus('Freetown', 'Kabala', 252.7),
      bus('Freetown', 'Kenema', 236.9),
      bus('Freetown', 'Bo', 205.3),
      bus('Freetown', 'Kambia', 189.6),
      bus('Freetown', 'Makeni', 189.6),
      bus('Freetown', 'Port Loko', 189.6),
      bus('Freetown', 'Moyamba', 205.3),
      bus('Freetown', 'Mattru/Bonthe', 221.2),
      bus('Freetown', 'Lunsar', 142.2),
      bus('Kenema', 'Kailahun', 190),
      bus('Kenema', 'Jendema', 292),
      bus('Kenema', 'Segbema', 118),
      bus('Kenema', 'Gendema', 332),
      bus('Kenema', 'Bo', 95),
      bus('Kenema', 'Pamalap', 411),
      bus('Kenema', 'Mattru Jong', 142),
      bus('Kenema', 'Rutile', 134),
      bus('Kenema', 'Gbangbatoke', 142),
      bus('Kenema', 'Makeni', 332),
      bus('Bo', 'Jendema', 213),
      bus('Bo', 'Taima', 71),
      bus('Bo', 'Pujehun', 103),
      bus('Bo', 'Magburaka', 63),
      bus('Bo', 'Kabala', 205, type: 'Per passenger (mini-bus)'),
      bus('Makeni', 'Kamabai', 79),
      bus('Makeni', 'Kono', 190),
      bus('Makeni', 'Lunsar', 95),
      bus('Makeni', 'Kamakwei', 205),

      // Poda-poda samples from news reports
      Tariff(mode: 'Poda-poda', from: 'Waterloo', to: 'Bombay Street', fare: 14.7, source: _news),
      Tariff(mode: 'Poda-poda', from: 'Waterloo', to: 'Tokeh', fare: 30.7, source: _news),
    ];
  }
}
