import 'country_service.dart';

/// The outcome of checking a phone number.
class PhoneResult {
  const PhoneResult({this.error, this.e164, this.country});

  final String? error;

  /// The number in international form, e.g. +23276123456.
  final String? e164;

  /// The country found from the calling code (null when the code is unknown).
  final Country? country;

  bool get isValid => error == null;
}

/// Checks phone numbers and finds the country from the calling code.
/// Sierra Leone numbers can be typed locally (076 123 456) or as +232 76 123 456.
/// Numbers from other countries must start with + and the country code.
class PhoneService {
  PhoneService._();

  static const String _help =
      'Use a Sierra Leone number like 076 123 456, or add your country code, e.g. +44 7700 900123';

  static PhoneResult parse(String? input) {
    final text = (input ?? '').trim();
    if (text.isEmpty) return const PhoneResult(error: 'Phone number is required');

    if (!RegExp(r'^\+?[0-9 ()\-.]+$').hasMatch(text)) {
      return const PhoneResult(error: 'Use digits only (and + before the country code)');
    }

    var digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    var international = text.startsWith('+');
    if (!international && digits.startsWith('00')) {
      digits = digits.substring(2);
      international = true;
    }

    // Local Sierra Leone formats
    if (!international) {
      if (digits.length == 9 && digits.startsWith('0')) {
        return _sierraLeone(digits.substring(1));
      }
      if (digits.length == 8 && !digits.startsWith('0')) {
        return _sierraLeone(digits);
      }
      return const PhoneResult(error: _help);
    }

    final country = CountryService.fromDigits(digits);
    if (country != null && country.isSierraLeone) {
      var national = digits.substring(country.dialCode.length);
      if (national.length == 9 && national.startsWith('0')) national = national.substring(1);
      return _sierraLeone(national);
    }

    if (digits.length < 8 || digits.length > 15 || digits.startsWith('0')) {
      return const PhoneResult(error: 'Enter a valid number with its country code, e.g. +44 7700 900123');
    }
    final national = country == null ? digits : digits.substring(country.dialCode.length);
    if (national.length < 6) {
      return const PhoneResult(error: 'That number is too short for this country code');
    }
    final fake = _looksFake(national);
    if (fake != null) return PhoneResult(error: fake);
    return PhoneResult(e164: '+$digits', country: country);
  }

  static PhoneResult _sierraLeone(String national) {
    if (national.length != 8) {
      return const PhoneResult(error: 'A Sierra Leone number has 8 digits after +232, e.g. 76 123 456');
    }
    if (national.startsWith('0') || national.startsWith('1')) {
      return const PhoneResult(error: 'A Sierra Leone number cannot start with 0 or 1 after +232');
    }
    final fake = _looksFake(national);
    if (fake != null) return PhoneResult(error: fake);
    return PhoneResult(e164: '+232$national', country: CountryService.sierraLeone);
  }

  /// Catches made-up numbers such as 00000000, 77000000 or 12345678.
  static String? _looksFake(String national) {
    final counts = <String, int>{};
    for (final ch in national.split('')) {
      counts[ch] = (counts[ch] ?? 0) + 1;
    }
    final most = counts.values.fold<int>(0, (a, b) => a > b ? a : b);
    if (most >= (national.length * 3 / 4).ceil()) {
      return 'That number has too many repeated digits. Please enter your real number';
    }
    const up = '01234567890123456789';
    const down = '98765432109876543210';
    if (up.contains(national) || down.contains(national)) {
      return 'That number looks made up. Please enter your real number';
    }
    return null;
  }

  static String? validate(String? input) => parse(input).error;

  /// Nice display text for a saved number, e.g. +232 76 123 456.
  static String display(String e164) {
    if (e164.startsWith('+232') && e164.length == 12) {
      final n = e164.substring(4);
      return '+232 ${n.substring(0, 2)} ${n.substring(2, 5)} ${n.substring(5)}';
    }
    return e164;
  }
}
