/// Shows prices in other currencies for visitors from overseas.
///
/// Rates are NLe per 1 unit of foreign currency, from the Bank of Sierra Leone
/// reference rates of 5 June 2026. They are indicative only and change every
/// day. Update this table to refresh them.
class CurrencyService {
  CurrencyService._();

  static const String ratesDate = '5 June 2026';

  static const Map<String, double> nlePerUnit = {
    'USD': 22.6848,
    'GBP': 30.5247,
    'EUR': 26.4020,
    'CNY': 3.3508,
  };

  /// Choices shown in Settings. 'NLe' means leones only.
  static const List<String> options = ['NLe', 'USD', 'EUR', 'GBP', 'CNY'];

  static String nameOf(String code) {
    switch (code) {
      case 'USD':
        return 'US dollar (USD)';
      case 'EUR':
        return 'Euro (EUR)';
      case 'GBP':
        return 'British pound (GBP)';
      case 'CNY':
        return 'Chinese yuan (CNY)';
      default:
        return 'New leone only (NLe)';
    }
  }

  /// Converts a leone amount, or null when no other currency is chosen.
  static double? convert(double nle, String code) {
    final rate = nlePerUnit[code];
    if (rate == null) return null;
    return nle / rate;
  }

  /// Text such as "about USD 0.53", or null when only leones are shown.
  static String? secondary(double? nle, String code) {
    if (nle == null) return null;
    final value = convert(nle, code);
    if (value == null) return null;
    return 'about $code ${value.toStringAsFixed(2)}';
  }
}
