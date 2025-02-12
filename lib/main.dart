// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import './models/pokemon.dart';
import './pokemon_provider.dart';
import './services/pokemon_colors.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PokemonProvider(),
      child: const PokemonApp(),
    ),
  );
}

class PokemonApp extends StatelessWidget {
  const PokemonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Battle',
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: GoogleFonts.pressStart2pTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const PokemonListScreen(),
    );
  }
}

// pokemon_list_screen.dart
class PokemonListScreen extends StatelessWidget {
  const PokemonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.groups),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TeamScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Consumer<PokemonProvider>(
        builder: (context, provider, child) {
          if (provider.allPokemons.isEmpty) {
            provider.loadPokemons();
            return const Center(child: CircularProgressIndicator());
          }

          final pokemonsToDisplay = provider.filteredPokemons.isEmpty
              ? provider.allPokemons
              : provider.filteredPokemons;

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
            ),
            itemCount: pokemonsToDisplay.length,
            itemBuilder: (context, index) {
              final pokemon = pokemonsToDisplay[index];
              return PokemonCard(pokemon: pokemon);
            },
          );
        },
      ),
    );
  }

  // Fonction pour afficher la fenêtre modale de filtre
  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sélectionner un type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Liste des types de Pokémon
              Expanded(
                child: ListView(
                  children: [
                    'normal',
                    'fire',
                    'water',
                    'grass',
                    'electric',
                    'psychic',
                    'rock',
                    'ground',
                    'flying',
                    'dark',
                    'dragon',
                    'steel',
                    'poison',
                    'fighting',
                    'ice',
                    'fairy',
                    'bug',
                    'ghost'
                  ].map((type) {
                    return CheckboxListTile(
                      title: Text(type),
                      value: context
                          .watch<PokemonProvider>()
                          .selectedTypes
                          .contains(type),
                      onChanged: (bool? selected) {
                        context
                            .read<PokemonProvider>()
                            .toggleTypeSelection(type, selected ?? false);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// pokemon_card.dart
class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PokemonDetailScreen(pokemon: pokemon),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                pokemon.imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    pokemon.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Wrap(
                    spacing: 4,
                    children: pokemon.types.map((type) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: getTypeColor(type),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          type,
                          style: const TextStyle(
                            color: Colors
                                .white, // Texte blanc pour une meilleure lisibilité
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// pokemon_detail_screen.dart
class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pokemon.name), backgroundColor: Colors.red,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                pokemon.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: pokemon.types.map((type) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: getTypeColor(type),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          type,
                          style: const TextStyle(
                            color: Colors
                                .white, // Texte blanc pour une meilleure lisibilité
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Statistiques',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  StatsWidget(stats: pokemon.stats),
                  const SizedBox(height: 16),
                  Consumer<PokemonProvider>(
                    builder: (context, provider, child) {
                      final isInTeam =
                          provider.playerTeam.pokemons.contains(pokemon);
                      return ElevatedButton(
                        onPressed: () {
                          if (isInTeam) {
                            provider.removeFromPlayerTeam(pokemon);
                          } else {
                            provider.addToPlayerTeam(pokemon);
                          }
                        },
                        child: Text(
                          isInTeam
                              ? 'Retirer de l\'équipe'
                              : 'Ajouter à l\'équipe',
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// team_screen.dart
class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Équipes'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.casino),
            onPressed: () =>
                context.read<PokemonProvider>().generateComputerTeam(),
          ),
          IconButton(
            icon: const Icon(Icons.sports_kabaddi),
            onPressed: () => _startBattle(context),
          ),
        ],
      ),
      body: Consumer<PokemonProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildTeamSection(
                context,
                'Votre équipe',
                provider.playerTeam.pokemons,
                provider,
              ),
              const Divider(thickness: 2),
              _buildTeamSection(
                context,
                'Équipe adverse',
                provider.computerTeam.pokemons,
                provider,
                isComputerTeam: true,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTeamSection(
    BuildContext context,
    String title,
    List<Pokemon> pokemons,
    PokemonProvider provider, {
    bool isComputerTeam = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.75,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                if (index < pokemons.length) {
                  return PokemonTeamCard(
                    pokemon: pokemons[index],
                    onRemove: isComputerTeam
                        ? null
                        : () => provider.removeFromPlayerTeam(pokemons[index]),
                  );
                }
                return const EmptyPokemonSlot();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _startBattle(BuildContext context) {
    final provider = context.read<PokemonProvider>();
    final result = provider.determineBattleWinner();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Résultat du combat'),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// widgets auxiliaires
class StatsWidget extends StatelessWidget {
  final Stats stats;

  const StatsWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatBar('PV', stats.hp),
        _buildStatBar('Attaque', stats.attack),
        _buildStatBar('Défense', stats.defense),
        _buildStatBar('Attaque Spé.', stats.specialAttack),
        _buildStatBar('Défense Spé.', stats.specialDefense),
        _buildStatBar('Vitesse', stats.speed),
      ],
    );
  }

  Widget _buildStatBar(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 255,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              value.toString(),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class PokemonTeamCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback? onRemove;

  const PokemonTeamCard({
    super.key,
    required this.pokemon,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Image.network(
                  pokemon.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  pokemon.name,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (onRemove != null)
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: onRemove,
              ),
            ),
        ],
      ),
    );
  }
}

class EmptyPokemonSlot extends StatelessWidget {
  const EmptyPokemonSlot({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Icon(
          Icons.catching_pokemon,
          size: 48,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
