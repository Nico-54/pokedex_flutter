class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final Stats stats;
  final String description;
  bool isSelected;
  final List<String> resistances;
  final List<String> imunes;
  final List<String> weaks;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.stats,
    required this.description,
    this.isSelected = false,
    required this.resistances,
    required this.imunes,
    required this.weaks,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    List<String> types = (json['types'] as List)
    .map((type) => type['type']['name'] as String)
    .toList();

    List<String> getResistances(List<String> types) {
      final Map<String, List<String>> typeResistances = {
      'steel': ['normal', 'grass', 'ice', 'flying', 'psychic', 'bug', 'rock', 'dragon', 'steel', 'fairy'],
      'fighting': ['bug', 'rock', 'dark'],
      'dragon': ['water', 'electric', 'fire', 'grass'],
      'water': ['fire', 'water', 'ice', 'steel'],
      'electric': ['electric', 'flying', 'steel'],
      'fairy': ['fighting', 'bug', 'dark'],
      'fire': ['fire', 'grass', 'ice', 'bug', 'steel', 'fairy'],
      'ice': ['ice'],
      'bug': ['fighting', 'grass', 'ground'],
      'grass': ['water', 'electric', 'grass', 'ground'],
      'poison': ['fighting', 'fairy', 'bug', 'grass', 'poison'],
      'psychic': ['fighting', 'psychic'],
      'rock': ['normal', 'fire', 'poison', 'flying'],
      'ground': ['poison', 'rock'],
      'ghost': ['bug', 'poison'],
      'dark': ['ghost', 'dark'],
      'flying': ['fighting', 'bug', 'grass'],
    };

    Set<String> resistances = {};
  
    for (var type in types) {
      if (typeResistances.containsKey(type)) {
        resistances.addAll(typeResistances[type]!);
      }
    }
  
    return resistances.toList();
  }
    List<String> getImunes(List<String> types) {
      final Map<String, List<String>> typeImunes = {
      'fairy': ['dragon'],
      'normal': ['ghost'],
      'ground': ['electric'],
      'ghost': ['fighting', 'normal'],
      'dark': ['psychic'],
      'flying': ['ground'],
    };

    Set<String> imunes = {};

    for (var type in types) {
      if (typeImunes.containsKey(type)) {
        imunes.addAll(typeImunes[type]!);
      }
    }

    return imunes.toList();
  }
    List<String> getWeaks(List<String> types) {
      final Map<String, List<String>> typeWeaks = {
      'steel': ['flying', 'fire', 'ground'],
      'fighting': ['psychic', 'fairy', 'flying'],
      'dragon': ['dragon', 'fairy', 'ice'],
      'water': ['electric', 'grace'],
      'electric': ['ground'],
      'fairy': ['steel', 'poison'],
      'fire': ['water', 'ground', 'rock'],
      'ice': ['steel', 'fighting', 'fire', 'rock'],
      'bug': ['fire', 'rock'],
      'normal': ['fighting'],
      'grass': ['fire', 'ice', 'bug', 'poison', 'flying'],
      'poison': ['psychic', 'ground'],
      'psychic': ['bug', 'ghost', 'dark'],
      'rock': ['steel', 'fighting', 'water', 'grass', 'ground'],
      'ground': ['water', 'ice', 'grass'],
      'ghost': ['ghost', 'dark'],
      'dark': ['fighting', 'fairy', 'bug'],
      'flying': ['electric', 'ice', 'rock'],
    };

    Set<String> weaks = {};

    for (var type in types) {
      if (typeWeaks.containsKey(type)) {
        weaks.addAll(typeWeaks[type]!);
      }
    }

    return weaks.toList();
  }


    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'],
      types: (json['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList(),
      stats: Stats.fromJson(json['stats']),
      description: json['description'] ?? '',
      resistances: getResistances(types),
      imunes: getImunes(types),
      weaks: getWeaks(types),
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
