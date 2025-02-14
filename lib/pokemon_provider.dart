//lib/providers/pokemon_provider.dart
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:hive/hive.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class PokemonProvider with ChangeNotifier {
  final PokemonService _service = PokemonService();
  List<Pokemon> _allPokemons = [];
  List<Pokemon> filteredPokemons = [];
  List<String> selectedTypes = [];

  Box<Pokemon> _favoriteBox = Hive.box<Pokemon>('favorites');

  final Team _playerTeam = Team(pokemons: []);
  final Team _computerTeam = Team(pokemons: [], isComputerTeam: true);
  String searchQuery = '';

  List<Pokemon> get allPokemons => _allPokemons;
  List<Pokemon> get favorites => _favoriteBox.values.toList();
  Team get playerTeam => _playerTeam;
  Team get computerTeam => _computerTeam;

  Future<void> loadPokemons() async {
    _allPokemons = await _service.getPokemonList();
    notifyListeners();
  }

  PokemonProvider() {
    _loadFavorites();
  }
  Future<void> _loadFavorites() async {
    _favoriteBox = await Hive.openBox<Pokemon>('favorites');
    notifyListeners();
  }

  // Champ de recherche
  void searchPokemons(String query) {
    searchQuery = query.toLowerCase();
    if (searchQuery.isEmpty) {
      filteredPokemons = allPokemons;
    } else {
      filteredPokemons = allPokemons
          .where((pokemon) =>
              pokemon.name.toLowerCase().contains(searchQuery))
          .toList();
    }
    notifyListeners();
  }

  // Selection du type
  void toggleTypeSelection(String type, bool isSelected) {
    if (isSelected) {
      selectedTypes.add(type);
    } else {
      selectedTypes.remove(type);
    }
    filterByType();
    notifyListeners();
  }

  void filterByType() {
    if (selectedTypes.isEmpty) {
      filteredPokemons = [];
    } else {
      filteredPokemons = allPokemons
          .where((pokemon) =>
              selectedTypes.any((type) => pokemon.types.contains(type)))
          .toList();
    }
    notifyListeners(); // Notifie l'UI pour actualiser la liste
  }

// Favoris
  void toggleFavorite(Pokemon pokemon) {
    if (_favoriteBox.containsKey(pokemon.id)) {
      _favoriteBox.delete(pokemon.id);
    } else {
      _favoriteBox.put(pokemon.id, pokemon);
    }
    notifyListeners();
  }

  // Ajout équipe du joueur
  void addToPlayerTeam(Pokemon pokemon, BuildContext context) {
    if (_playerTeam.isFull) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Votre équipe est pleine !"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return; // On empêche l'ajout
    }

    if (!_playerTeam.pokemons.contains(pokemon)) {
      pokemon.isSelected = true;
      _playerTeam.pokemons.add(pokemon);
      notifyListeners();
    }
  }

  // Retirer équipe du joueur
  void removeFromPlayerTeam(Pokemon pokemon) {
    pokemon.isSelected = false;
    _playerTeam.pokemons.remove(pokemon);
    notifyListeners();
  }

  // Génération de l'équipe adverse
  void generateComputerTeam() {
    final random = Random();
    _computerTeam.pokemons.clear();

    while (_computerTeam.pokemons.length < 6) {
      final randomPokemon = _allPokemons[random.nextInt(_allPokemons.length)];
      if (!_computerTeam.pokemons.contains(randomPokemon)) {
        _computerTeam.pokemons.add(randomPokemon);
      }
    }
    notifyListeners();
  }

  // Gagnant du combat
  String determineBattleWinner() {
    if (_playerTeam.pokemons.length != 6 ||
        _computerTeam.pokemons.length != 6) {
      return "Les deux équipes doivent avoir 6 Pokémon";
    }

    final playerPower = _playerTeam.totalPower;
    final computerPower = _computerTeam.totalPower;

    if (playerPower > computerPower) {
      return "Vous avez gagné !\nVous : ${playerPower}\nAdversaire : ${computerPower})";
    } else if (computerPower > playerPower) {
      return "L'ordinateur a gagné !\nAdversaire : ${computerPower}\nVous : ${playerPower}";
    } else {
      return "Match nul ! (${playerPower})";
    }
  }
}
