import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> getPokemonList({int limit = 151}) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=$limit'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      final pokemons = await Future.wait(
          results.map((pokemon) => getPokemonDetails(pokemon['url'])).toList());

      return pokemons;
    } else {
      throw Exception('Échec du chargement des Pokémon');
    }
  }

  Future<Pokemon> getPokemonDetails(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Récupérer la description
      final speciesResponse =
          await http.get(Uri.parse('$baseUrl/pokemon-species/${data['id']}'));

      if (speciesResponse.statusCode == 200) {
        final speciesData = json.decode(speciesResponse.body);
        final description = speciesData['flavor_text_entries'].firstWhere(
            (entry) => entry['language']['name'] == 'fr')['flavor_text'];

        data['description'] = description;
        return Pokemon.fromJson(data);
      } else {
        throw Exception('Échec du chargement des détails du Pokémon');
      }
    } else {
      throw Exception('Échec du chargement des détails du Pokémon');
    }
  }
}
