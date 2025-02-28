import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';

part 'pokemon.g.dart'; // Génère le fichier d'adapteur

@HiveType(typeId: 0)
class Pokemon {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String sprites;

  @HiveField(3)
  final String shinySprites;

  @HiveField(4)
  final String? gmaxSprites;

  @HiveField(5)
  final List<PokemonType> types;
  
  @HiveField(6)
  final Stats stats;

  @HiveField(7)
  final String category;

  @HiveField(8)
  final int generation;

  @HiveField(9)
  final Evolution? evolution;
  
  @HiveField(10)
  bool isSelected;

  Pokemon({
    required this.id,
    required this.name,
    required this.sprites,
    required this.shinySprites,
    this.gmaxSprites,
    required this.types,
    required this.stats,
    required this.category,
    required this.generation,
    this.isSelected = false,
    this.evolution,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
debugPrint("Chargement du Pokémon: ${json['name'] ?? 'Inconnu'}"); 
    return Pokemon(
      id: json['pokedex_id'],
      name: json['name'],
      sprites: json['sprites']['regular'],
      shinySprites: json['sprites']['shiny'],
      gmaxSprites: json['sprites']['gmax'],
      generation: json['generation'],
      types: (json['types'] as List<dynamic>)
          .map((typeJson) => PokemonType(
                name: typeJson['name'],
                imageUrl: typeJson['image'],
              ))
          .toList(),
      stats: Stats.fromJson(json['stats']),
      category: json['category'] ?? '',
      evolution: json['evolution'] != null
          ? Evolution.fromJson(json['evolution'])
          : null,
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

@HiveType(typeId: 3)
class Evolution {
  @HiveField(0)
  final List<EvolutionStep>? pre;

  @HiveField(1)
  final List<EvolutionStep>? next;

  Evolution({this.pre, this.next});

  factory Evolution.fromJson(Map<String, dynamic> json) {
    debugPrint("Création de Evolution avec: $json");
    return Evolution(
      pre: json['pre'] != null
          ? (json['pre'] as List<dynamic>)
              .map((e) => EvolutionStep.fromJson(e))
              .toList()
          : null,
      next: json['next'] != null
          ? (json['next'] as List<dynamic>)
              .map((e) => EvolutionStep.fromJson(e))
              .toList()
          : null,
    );
  }
}

@HiveType(typeId: 4)
class EvolutionStep {
  @HiveField(0)
  final int pokedexId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String condition;

  EvolutionStep({
    required this.pokedexId,
    required this.name,
    required this.condition,
  });

  factory EvolutionStep.fromJson(Map<String, dynamic> json) {
    return EvolutionStep(
      pokedexId: json['pokedex_id'],
      name: json['name'],
      condition: json['condition'],
    );
  }
}
