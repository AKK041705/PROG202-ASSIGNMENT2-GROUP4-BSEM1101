import '../services/phone_service.dart';

/// Form validation rules shared by every form in the app.
class Validators {
  Validators._();

  static String? required(String? value, [String label = 'This field']) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  static String? username(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return 'Username is required';
    if (text.contains(' ')) return 'Username cannot contain spaces';
    if (text.length < 3) return 'Use at least 3 characters';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 4) return 'Use at least 4 characters';
    return null;
  }

  /// Checks the number and its country code (see PhoneService).
  static String? phone(String? value) => PhoneService.validate(value);

  static String? amount(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return 'Enter an amount';
    final number = double.tryParse(text);
    if (number == null) return 'Enter a number';
    if (number <= 0) return 'Amount must be more than 0';
    return null;
  }
}
