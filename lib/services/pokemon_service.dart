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
          name: (pokemon['name'] is Map) ? pokemon['name']['fr'] ?? 'Nom Inconnu' : (pokemon['name'] ?? 'Nom Inconnu'),
          sprites: (pokemon['sprites'] is Map) ? pokemon['sprites']['regular'] ?? '' : '',
          shinySprites: (pokemon['sprites'] is Map) ? pokemon['sprites']['shiny'] ?? '' : '',
          gmaxSprites: (pokemon['sprites']['gmax'] is Map) 
              ? pokemon['sprites']['gmax']['regular'] ?? '' 
              : '',
          types: (pokemon['types'] is List)
              ? (pokemon['types'] as List).map<PokemonType>((type) => PokemonType(
                  name: type['name'] ?? 'Type Inconnu',
                  imageUrl: type['image'] ?? '',
                )).toList()
              : [PokemonType(name: '', imageUrl: '')],
          stats: (pokemon['stats'] is Map)
              ? Stats(
                  hp: pokemon['stats']['hp'] ?? 0,
                  attack: pokemon['stats']['atk'] ?? 0,
                  defense: pokemon['stats']['def'] ?? 0,
                  specialAttack: pokemon['stats']['spe_atk'] ?? 0,
                  specialDefense: pokemon['stats']['spe_def'] ?? 0,
                  speed: pokemon['stats']['vit'] ?? 0,
                )
              : Stats(hp: 0, attack: 0, defense: 0, specialAttack: 0, specialDefense: 0, speed: 0),
          category: pokemon['category'] ?? 'Catégorie inconnue',
          generation: pokemon['generation'] ?? 'Génération inconnue',
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

        // Gestion de l'évolution
        Evolution? evolution;
        if (data['evolution'] != null && data['evolution'] is Map) {
          try {
            // Extraction des évolutions précédentes
            List<EvolutionStep>? preEvolutions;
            if (data['evolution']['pre'] != null) {
              preEvolutions = (data['evolution']['pre'] as List)
                  .map<EvolutionStep>((e) => EvolutionStep(
                        pokedexId: e['pokedex_id'],
                        name: e['name'],
                        condition: e['condition'] ?? '',
                      ))
                  .toList();
            }

            // Extraction des évolutions suivantes
            List<EvolutionStep>? nextEvolutions;
            if (data['evolution']['next'] != null) {
              nextEvolutions = (data['evolution']['next'] as List)
                  .map<EvolutionStep>((e) => EvolutionStep(
                        pokedexId: e['pokedex_id'],
                        name: e['name'],
                        condition: e['condition'] ?? '',
                      ))
                  .toList();
            }

            // Création de l'objet Evolution
            evolution = Evolution(
              pre: preEvolutions,
              next: nextEvolutions,
            );
          } catch (e) {
            print("Erreur lors du traitement des évolutions: $e");
            evolution = null;
          }
        }

        return Pokemon(
          id: data['pokedex_id'] ?? 0,
          name: data['name']['fr'] ?? 'Nom Inconnu',
          sprites: data['sprites']['regular'] ?? '',
          shinySprites: data['sprites']['shiny'] ?? '',
          gmaxSprites: data['sprites']['gmax'] ?? '',
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
          generation: data['generation'] ?? 'Génération inconnue',
          evolution: evolution,
        );
      } else {
        throw Exception('Erreur ${response.statusCode} lors du chargement des détails du Pokémon.');
      }
    } catch (e) {
      throw Exception('Erreur lors du chargement des détails du Pokémon : $e');
    }
  }
}
