class Country {
  final String name;
  final String code;
  final String? capital;
  final String continent;

  const Country({
    required this.name,
    required this.code,
    this.capital,
    required this.continent,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    final rawName = json['name'];
    final rawCode = json['code'];
    final rawCapital = json['capital'];
    final continentData = json['continent'];
    final rawContinentName =
        continentData is Map ? continentData['name'] : null;

    return Country(
      name: rawName is String && rawName.trim().isNotEmpty
          ? rawName.trim()
          : 'Unknown country',
      code: rawCode is String && rawCode.trim().isNotEmpty
          ? rawCode.trim()
          : '--',
      capital: rawCapital is String && rawCapital.trim().isNotEmpty
          ? rawCapital.trim()
          : null,
      continent: rawContinentName is String &&
              rawContinentName.trim().isNotEmpty
          ? rawContinentName.trim()
          : 'Unknown',
    );
  }
}
