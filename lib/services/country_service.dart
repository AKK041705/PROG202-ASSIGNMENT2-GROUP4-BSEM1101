/// A country, found from the start of a phone number (its calling code).
class Country {
  const Country(this.name, this.dialCode, this.currency);

  final String name;
  final String dialCode; // digits only, e.g. '232'
  final String currency; // currency used to show prices: NLe, USD, EUR, GBP or CNY

  bool get isSierraLeone => dialCode == '232';
}

class CountryService {
  CountryService._();

  static const Country sierraLeone = Country('Sierra Leone', '232', 'NLe');

  /// Prices are shown in NLe, USD, EUR, GBP or CNY. Countries that use another
  /// currency are shown in USD.
  static const List<Country> countries = [
    sierraLeone,
    Country('United States / Canada', '1', 'USD'),
    Country('United Kingdom', '44', 'GBP'),
    Country('France', '33', 'EUR'),
    Country('Germany', '49', 'EUR'),
    Country('Italy', '39', 'EUR'),
    Country('Spain', '34', 'EUR'),
    Country('Netherlands', '31', 'EUR'),
    Country('Belgium', '32', 'EUR'),
    Country('Portugal', '351', 'EUR'),
    Country('Ireland', '353', 'EUR'),
    Country('Austria', '43', 'EUR'),
    Country('Greece', '30', 'EUR'),
    Country('Finland', '358', 'EUR'),
    Country('China', '86', 'CNY'),
    Country('Hong Kong', '852', 'USD'),
    Country('Japan', '81', 'USD'),
    Country('South Korea', '82', 'USD'),
    Country('India', '91', 'USD'),
    Country('Pakistan', '92', 'USD'),
    Country('Bangladesh', '880', 'USD'),
    Country('Singapore', '65', 'USD'),
    Country('Malaysia', '60', 'USD'),
    Country('Indonesia', '62', 'USD'),
    Country('Turkey', '90', 'USD'),
    Country('United Arab Emirates', '971', 'USD'),
    Country('Saudi Arabia', '966', 'USD'),
    Country('Russia / Kazakhstan', '7', 'USD'),
    Country('Australia', '61', 'USD'),
    Country('New Zealand', '64', 'USD'),
    Country('Brazil', '55', 'USD'),
    Country('Mexico', '52', 'USD'),
    Country('Nigeria', '234', 'USD'),
    Country('Ghana', '233', 'USD'),
    Country('Liberia', '231', 'USD'),
    Country('Guinea', '224', 'USD'),
    Country('Senegal', '221', 'USD'),
    Country('Gambia', '220', 'USD'),
    Country("Cote d'Ivoire", '225', 'USD'),
    Country('Cameroon', '237', 'USD'),
    Country('DR Congo', '243', 'USD'),
    Country('Angola', '244', 'USD'),
    Country('South Africa', '27', 'USD'),
    Country('Kenya', '254', 'USD'),
    Country('Tanzania', '255', 'USD'),
    Country('Uganda', '256', 'USD'),
    Country('Rwanda', '250', 'USD'),
    Country('Ethiopia', '251', 'USD'),
    Country('Zambia', '260', 'USD'),
    Country('Zimbabwe', '263', 'USD'),
    Country('Egypt', '20', 'USD'),
    Country('Morocco', '212', 'USD'),
    Country('Tunisia', '216', 'USD'),
  ];

  /// Finds the country whose calling code starts [digits] (longest match wins).
  static Country? fromDigits(String digits) {
    Country? best;
    for (final country in countries) {
      if (digits.startsWith(country.dialCode)) {
        if (best == null || country.dialCode.length > best.dialCode.length) {
          best = country;
        }
      }
    }
    return best;
  }
}
