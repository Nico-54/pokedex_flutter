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
  final List<PokemonType> types;
  
  @HiveField(4)
  final Stats stats;

  @HiveField(5)
  final String category;
  
  @HiveField(6)
  bool isSelected;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.stats,
    required this.category,
    this.isSelected = false,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {

    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']?['other']?['official-artwork']?['front_default'] ?? '',
      types: (json['types'] as List<dynamic>)
          .map((typeJson) => PokemonType(
                name: typeJson['name'],
                imageUrl: typeJson['image'],
              ))
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

@HiveType(typeId: 2)
class PokemonType {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String imageUrl;

  PokemonType({
    required this.name,
    required this.imageUrl,
  });
}
