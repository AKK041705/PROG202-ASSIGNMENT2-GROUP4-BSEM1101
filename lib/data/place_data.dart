/// A place a passenger can travel from or to.
/// [km] is an approximate simulated road distance from central Freetown.
class Place {
  const Place(this.name, this.area, this.km);

  final String name;
  final String area;
  final int km;

  bool get isWesternArea => area == 'City' || area == 'Peninsula';
}

const List<Place> kPlaces = [
  // Freetown city
  Place('Freetown', 'City', 0),
  Place('PZ', 'City', 1),
  Place('Bombay Street', 'City', 3),
  Place('Douzak', 'City', 3),
  Place('Wilberforce', 'City', 4),
  Place('Imatt', 'City', 4),
  Place('Model', 'City', 4),
  Place('Up-gun', 'City', 5),
  Place('Aberdeen', 'City', 5),
  Place('Aberdeen Road Junction', 'City', 6),
  Place('Wilkinson Road', 'City', 6),
  Place('Congo Cross', 'City', 6),
  Place('Lumley', 'City', 7),
  Place('Regent', 'City', 9),
  Place('Bah Junction', 'City', 9),
  Place('Levumaa Beach', 'City', 9),
  Place('Funkia Junction', 'City', 9),
  Place('Femi Turner', 'City', 10),
  Place('College Junction', 'City', 10),
  Place('Ogu Farm Junction', 'City', 11),
  Place('Laka Junction', 'City', 12),
  Place('Hamilton Junction', 'City', 12),
  Place('Mambo Junction', 'City', 14),
  // Western Area peninsula
  Place('Calaba Town', 'Peninsula', 14),
  Place('Jui', 'Peninsula', 17),
  Place('Yams Farm', 'Peninsula', 20),
  Place('Tombo Junction', 'Peninsula', 29),
  Place('Waterloo 55', 'Peninsula', 33),
  Place('Kerry Town', 'Peninsula', 34),
  Place('Devil Hole', 'Peninsula', 34),
  Place('Fire Force', 'Peninsula', 34),
  Place('Waterloo', 'Peninsula', 35),
  Place('Rokel', 'Peninsula', 36),
  Place('4 Mile', 'Peninsula', 38),
  Place('Crossing', 'Peninsula', 40),
  Place('Brama', 'Peninsula', 42),
  Place('Tombo', 'Peninsula', 45),
  Place('Songo', 'Peninsula', 50),
  Place('Tokeh', 'Peninsula', 55),
  // Lungi
  Place('Lungi', 'Lungi', 40),
  // North
  Place('Port Loko', 'North', 90),
  Place('Lunsar', 'North', 105),
  Place('Kambia', 'North', 150),
  Place('Makeni', 'North', 180),
  Place('Kamabai', 'North', 220),
  Place('Kamakwei', 'North', 250),
  Place('Kabala', 'North', 290),
  // South and East
  Place('Moyamba', 'Southeast', 130),
  Place('Gbangbatoke', 'Southeast', 200),
  Place('Magburaka', 'Southeast', 215),
  Place('Mattru/Bonthe', 'Southeast', 215),
  Place('Mattru Jong', 'Southeast', 220),
  Place('Rutile', 'Southeast', 230),
  Place('Bo', 'Southeast', 250),
  Place('Taima', 'Southeast', 270),
  Place('Jendema', 'Southeast', 300),
  Place('Kenema', 'Southeast', 300),
  Place('Pujehun', 'Southeast', 300),
  Place('Kono', 'Southeast', 330),
  Place('Segbema', 'Southeast', 330),
  Place('Pamalap', 'Southeast', 340),
  Place('Gendema', 'Southeast', 360),
  Place('Kailahun', 'Southeast', 380),
];
