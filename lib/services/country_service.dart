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
    // West Africa
    Country('Benin', '229', 'USD'),
    Country('Burkina Faso', '226', 'USD'),
    Country('Cabo Verde', '238', 'USD'),
    Country("Cote d'Ivoire", '225', 'USD'),
    Country('Gambia', '220', 'USD'),
    Country('Ghana', '233', 'USD'),
    Country('Guinea', '224', 'USD'),
    Country('Guinea-Bissau', '245', 'USD'),
    Country('Liberia', '231', 'USD'),
    Country('Mali', '223', 'USD'),
    Country('Mauritania', '222', 'USD'),
    Country('Niger', '227', 'USD'),
    Country('Nigeria', '234', 'USD'),
    Country('Senegal', '221', 'USD'),
    Country('Togo', '228', 'USD'),
    // Other Africa
    Country('Algeria', '213', 'USD'),
    Country('Morocco', '212', 'USD'),
    Country('Tunisia', '216', 'USD'),
    Country('Libya', '218', 'USD'),
    Country('Egypt', '20', 'USD'),
    Country('Sudan', '249', 'USD'),
    Country('South Sudan', '211', 'USD'),
    Country('Ethiopia', '251', 'USD'),
    Country('Eritrea', '291', 'USD'),
    Country('Djibouti', '253', 'USD'),
    Country('Somalia', '252', 'USD'),
    Country('Kenya', '254', 'USD'),
    Country('Uganda', '256', 'USD'),
    Country('Tanzania', '255', 'USD'),
    Country('Rwanda', '250', 'USD'),
    Country('Burundi', '257', 'USD'),
    Country('DR Congo', '243', 'USD'),
    Country('Republic of the Congo', '242', 'USD'),
    Country('Gabon', '241', 'USD'),
    Country('Equatorial Guinea', '240', 'USD'),
    Country('Cameroon', '237', 'USD'),
    Country('Central African Republic', '236', 'USD'),
    Country('Chad', '235', 'USD'),
    Country('Sao Tome and Principe', '239', 'USD'),
    Country('Angola', '244', 'USD'),
    Country('Zambia', '260', 'USD'),
    Country('Malawi', '265', 'USD'),
    Country('Mozambique', '258', 'USD'),
    Country('Zimbabwe', '263', 'USD'),
    Country('Botswana', '267', 'USD'),
    Country('Namibia', '264', 'USD'),
    Country('Lesotho', '266', 'USD'),
    Country('Eswatini', '268', 'USD'),
    Country('Madagascar', '261', 'USD'),
    Country('Mauritius', '230', 'USD'),
    Country('Seychelles', '248', 'USD'),
    Country('Comoros', '269', 'USD'),
    Country('South Africa', '27', 'USD'),
    // United Kingdom and China have their own price currency
    Country('United Kingdom', '44', 'GBP'),
    Country('China', '86', 'CNY'),
    // United States and Canada share +1
    Country('United States / Canada', '1', 'USD'),
    // Euro countries
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
    Country('Luxembourg', '352', 'EUR'),
    Country('Malta', '356', 'EUR'),
    Country('Cyprus', '357', 'EUR'),
    Country('Slovakia', '421', 'EUR'),
    Country('Slovenia', '386', 'EUR'),
    Country('Estonia', '372', 'EUR'),
    Country('Latvia', '371', 'EUR'),
    Country('Lithuania', '370', 'EUR'),
    Country('Croatia', '385', 'EUR'),
    // Other Europe
    Country('Sweden', '46', 'USD'),
    Country('Norway', '47', 'USD'),
    Country('Denmark', '45', 'USD'),
    Country('Switzerland', '41', 'USD'),
    Country('Poland', '48', 'USD'),
    Country('Czechia', '420', 'USD'),
    Country('Hungary', '36', 'USD'),
    Country('Romania', '40', 'USD'),
    Country('Bulgaria', '359', 'USD'),
    Country('Ukraine', '380', 'USD'),
    Country('Serbia', '381', 'USD'),
    Country('Iceland', '354', 'USD'),
    Country('Russia / Kazakhstan', '7', 'USD'),
    Country('Turkey', '90', 'USD'),
    // Asia
    Country('India', '91', 'USD'),
    Country('Pakistan', '92', 'USD'),
    Country('Bangladesh', '880', 'USD'),
    Country('Sri Lanka', '94', 'USD'),
    Country('Nepal', '977', 'USD'),
    Country('Japan', '81', 'USD'),
    Country('South Korea', '82', 'USD'),
    Country('Singapore', '65', 'USD'),
    Country('Malaysia', '60', 'USD'),
    Country('Indonesia', '62', 'USD'),
    Country('Philippines', '63', 'USD'),
    Country('Thailand', '66', 'USD'),
    Country('Vietnam', '84', 'USD'),
    Country('Hong Kong', '852', 'USD'),
    Country('Macau', '853', 'USD'),
    Country('Taiwan', '886', 'USD'),
    // Middle East
    Country('United Arab Emirates', '971', 'USD'),
    Country('Saudi Arabia', '966', 'USD'),
    Country('Qatar', '974', 'USD'),
    Country('Kuwait', '965', 'USD'),
    Country('Bahrain', '973', 'USD'),
    Country('Oman', '968', 'USD'),
    Country('Jordan', '962', 'USD'),
    Country('Lebanon', '961', 'USD'),
    Country('Israel', '972', 'USD'),
    Country('Iraq', '964', 'USD'),
    Country('Iran', '98', 'USD'),
    // Americas and Oceania
    Country('Mexico', '52', 'USD'),
    Country('Brazil', '55', 'USD'),
    Country('Argentina', '54', 'USD'),
    Country('Chile', '56', 'USD'),
    Country('Colombia', '57', 'USD'),
    Country('Peru', '51', 'USD'),
    Country('Venezuela', '58', 'USD'),
    Country('Cuba', '53', 'USD'),
    Country('Australia', '61', 'USD'),
    Country('New Zealand', '64', 'USD'),
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
