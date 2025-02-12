class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final Stats stats;
  final String description;
  bool isSelected;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.stats,
    required this.description,
    this.isSelected = false,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'],
      types: (json['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList(),
      stats: Stats.fromJson(json['stats']),
      description: json['description'] ?? '',
    );
  }

  int get totalStats => stats.total;
}

class Stats {
  final int hp;
  final int attack;
  final int defense;
  final int specialAttack;
  final int specialDefense;
  final int speed;

  Stats({
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
  });

  factory Stats.fromJson(List<dynamic> json) {
    return Stats(
      hp: json[0]['base_stat'],
      attack: json[1]['base_stat'],
      defense: json[2]['base_stat'],
      specialAttack: json[3]['base_stat'],
      specialDefense: json[4]['base_stat'],
      speed: json[5]['base_stat'],
    );
  }

  int get total =>
      hp + attack + defense + specialAttack + specialDefense + speed;
}

class Team {
  final List<Pokemon> pokemons;
  final bool isComputerTeam;

  Team({
    required this.pokemons,
    this.isComputerTeam = false,
  });

  bool get isFull => pokemons.length >= 6;
  int get totalPower =>
      pokemons.fold(0, (sum, pokemon) => sum + pokemon.totalStats);
}
