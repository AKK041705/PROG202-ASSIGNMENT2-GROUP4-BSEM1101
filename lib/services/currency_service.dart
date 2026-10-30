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

  /// Currencies a passenger can pay in. The price is always set in leones (NLe);
  /// a payment in another currency is recorded in that currency and is NOT
  /// converted to leones by this app.
  static const List<String> acceptedPayments = options;

  /// NLe per 1 unit of [code] (1 for NLe itself).
  static double rateFor(String code) => code == 'NLe' ? 1.0 : (nlePerUnit[code] ?? 1.0);

  /// The amount to pay in [code] for a price of [nle] leones, rounded to 2 decimals.
  static double amountIn(double nle, String code) {
    final value = nle / rateFor(code);
    return (value * 100).round() / 100;
  }

  /// "NLe 12.0" or "GBP 0.39".
  static String money(double value, String code) {
    return code == 'NLe' ? 'NLe ${value.toStringAsFixed(1)}' : '$code ${value.toStringAsFixed(2)}';
  }

  /// How a payment is described on screen.
  static String paymentText(String code, double? amount) {
    if (amount == null) return 'To be agreed with the driver';
    if (code == 'NLe') return money(amount, code);
    return '${money(amount, code)} (paid in $code, not converted to leones)';
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
