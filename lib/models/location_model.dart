class Country {
  final String name;

  Country({required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
    );
  }
}

class State {
  final String name;

  State({required this.name});

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      name: json['name'],
    );
  }
}

class City {
  final String name;

  City({required this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
    );
  }
}
