import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService {
  static const String baseUrl = 'https://tyradex.vercel.app/api/v1';

  Future<List<Pokemon>> getPokemonList() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pokemon'));

      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);

        return results.map((pokemon) => Pokemon(
          id: pokemon['pokedex_id'] ?? 0,
          name: pokemon['name']['fr'] ?? 'Nom Inconnu',
          imageUrl: pokemon['sprites']['regular'] ?? '',
          types: (pokemon['types'] == null) 
            ? [PokemonType(name: 'Type Inconnu', imageUrl: '')] 
            : (pokemon['types'] as List).map<PokemonType>((type) => PokemonType(
                name: type['name'] ?? 'Type inconnu',
                imageUrl: type['image'] ?? '',
              )).toList(),
          stats: (pokemon['stats'] == null)
            ? Stats(hp: 0, attack: 0, defense: 0, specialAttack: 0, specialDefense: 0, speed: 0)
            : Stats(
                hp: pokemon['stats']['hp'] ?? 0,
                attack: pokemon['stats']['atk'] ?? 0,
                defense: pokemon['stats']['def'] ?? 0,
                specialAttack: pokemon['stats']['spe_atk'] ?? 0,
                specialDefense: pokemon['stats']['spe_def'] ?? 0,
                speed: pokemon['stats']['vit'] ?? 0,
              ),
          category: pokemon['category'] ?? 'Catégorie inconnue',
        )).toList();
      } else {
        throw Exception('Erreur ${response.statusCode} lors du chargement des Pokémon.');
      }
    } catch (e) {
      throw Exception('Erreur lors du chargement de la liste des Pokémon : $e');
    }
  }

  Future<Pokemon> getPokemonDetails(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pokemon/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return Pokemon(
          id: data['pokedex_id'] ?? 0,
          name: data['name']['fr'] ?? 'Nom Inconnu',
          imageUrl: data['sprites']['regular'] ?? '',
          types: (data['types'] == null) 
            ? [PokemonType(name: 'Type Inconnu', imageUrl: '')]
            : (data['types'] as List).map<PokemonType>((type) => PokemonType(
                name: type['name'] ?? 'Type inconnu',
                imageUrl: type['image'] ?? '',
              )).toList(),
          stats: (data['stats'] == null)
            ? Stats(hp: 0, attack: 0, defense: 0, specialAttack: 0, specialDefense: 0, speed: 0)
            : Stats.fromJson(data['stats']),
          category: data['category'] ?? 'Catégorie inconnue',
        );
      } else {
        throw Exception('Erreur ${response.statusCode} lors du chargement des détails du Pokémon.');
      }
    } catch (e) {
      throw Exception('Erreur lors du chargement des détails du Pokémon : $e');
    }
  }
}
