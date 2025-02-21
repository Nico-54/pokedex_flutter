import 'package:hive/hive.dart';

part 'pokemon.g.dart'; // Génère le fichier d'adapteur

@HiveType(typeId: 0)
class Pokemon {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final List<String> types;
  
  @HiveField(4)
  final Stats stats;

  @HiveField(5)
  final String category;
  
  @HiveField(6)
  bool isSelected;
  
  // @HiveField(7)
  // final List<String> resistances;
  
  // @HiveField(8)
  // final List<String> imunes;
  
  // @HiveField(9)
  // final List<String> weaks;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.stats,
    required this.category,
    this.isSelected = false,
    // required this.resistances,
    // required this.imunes,
    // required this.weaks,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // List<String> types = (json['types'] as List)
    // .map((type) => type['type']['name'] as String)
    // .toList();

  //   List<String> getResistances(List<String> types) {
  //     final Map<String, List<String>> typeResistances = {
  //     'steel': ['normal', 'grass', 'ice', 'flying', 'psychic', 'bug', 'rock', 'dragon', 'steel', 'fairy'],
  //     'fighting': ['bug', 'rock', 'dark'],
  //     'dragon': ['water', 'electric', 'fire', 'grass'],
  //     'water': ['fire', 'water', 'ice', 'steel'],
  //     'electric': ['electric', 'flying', 'steel'],
  //     'fairy': ['fighting', 'bug', 'dark'],
  //     'fire': ['fire', 'grass', 'ice', 'bug', 'steel', 'fairy'],
  //     'ice': ['ice'],
  //     'bug': ['fighting', 'grass', 'ground'],
  //     'grass': ['water', 'electric', 'grass', 'ground'],
  //     'poison': ['fighting', 'fairy', 'bug', 'grass', 'poison'],
  //     'psychic': ['fighting', 'psychic'],
  //     'rock': ['normal', 'fire', 'poison', 'flying'],
  //     'ground': ['poison', 'rock'],
  //     'ghost': ['bug', 'poison'],
  //     'dark': ['ghost', 'dark'],
  //     'flying': ['fighting', 'bug', 'grass'],
  //   };

  //   Set<String> resistances = {};
  
  //   for (var type in types) {
  //     if (typeResistances.containsKey(type)) {
  //       resistances.addAll(typeResistances[type]!);
  //     }
  //   }
  
  //   return resistances.toList();
  // }
  //   List<String> getImunes(List<String> types) {
  //     final Map<String, List<String>> typeImunes = {
  //     'fairy': ['dragon'],
  //     'normal': ['ghost'],
  //     'ground': ['electric'],
  //     'ghost': ['fighting', 'normal'],
  //     'dark': ['psychic'],
  //     'flying': ['ground'],
  //   };

  //   Set<String> imunes = {};

  //   for (var type in types) {
  //     if (typeImunes.containsKey(type)) {
  //       imunes.addAll(typeImunes[type]!);
  //     }
  //   }

  //   return imunes.toList();
  // }
  //   List<String> getWeaks(List<String> types) {
  //     final Map<String, List<String>> typeWeaks = {
  //     'steel': ['flying', 'fire', 'ground'],
  //     'fighting': ['psychic', 'fairy', 'flying'],
  //     'dragon': ['dragon', 'fairy', 'ice'],
  //     'water': ['electric', 'grace'],
  //     'electric': ['ground'],
  //     'fairy': ['steel', 'poison'],
  //     'fire': ['water', 'ground', 'rock'],
  //     'ice': ['steel', 'fighting', 'fire', 'rock'],
  //     'bug': ['fire', 'rock'],
  //     'normal': ['fighting'],
  //     'grass': ['fire', 'ice', 'bug', 'poison', 'flying'],
  //     'poison': ['psychic', 'ground'],
  //     'psychic': ['bug', 'ghost', 'dark'],
  //     'rock': ['steel', 'fighting', 'water', 'grass', 'ground'],
  //     'ground': ['water', 'ice', 'grass'],
  //     'ghost': ['ghost', 'dark'],
  //     'dark': ['fighting', 'fairy', 'bug'],
  //     'flying': ['electric', 'ice', 'rock'],
  //   };

  //   Set<String> weaks = {};

  //   for (var type in types) {
  //     if (typeWeaks.containsKey(type)) {
  //       weaks.addAll(typeWeaks[type]!);
  //     }
  //   }

  //   return weaks.toList();
  // }


    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']?['other']?['official-artwork']?['front_default'] ?? '',
      types: (json['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList(),
      stats: Stats.fromJson(json['stats']),
      category: json['category'] ?? '',
      // resistances: getResistances(types),
      // imunes: getImunes(types),
      // weaks: getWeaks(types),
    );
  }

  int get totalStats => stats.total;
}

@HiveType(typeId: 1)
class Stats {
  @HiveField(0)
  final int hp;

  @HiveField(1)
  final int attack;
  
  @HiveField(2)
  final int defense;

  @HiveField(3)
  final int specialAttack;

  @HiveField(4)
  final int specialDefense;

  @HiveField(5)
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
      hp: json[0]['base_stat'] ?? 0,
      attack: json[1]['base_stat'] ?? 0,
      defense: json[2]['base_stat'] ?? 0,
      specialAttack: json[3]['base_stat'] ?? 0,
      specialDefense: json[4]['base_stat'] ?? 0,
      speed: json[5]['base_stat'] ?? 0,
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
