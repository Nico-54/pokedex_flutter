// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './models/pokemon.dart';
import './pokemon_provider.dart';
//import './services/pokemon_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PokemonAdapter());
  Hive.registerAdapter(StatsAdapter());
  Hive.registerAdapter(PokemonTypeAdapter());

  await Hive.openBox<Pokemon>('favorites');

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

class PokemonListByGeneration extends StatelessWidget {
  final List<Map<String, dynamic>> pokemons;

  const PokemonListByGeneration({super.key, required this.pokemons});

  @override
  Widget build(BuildContext context) {
    // Récupérer les générations uniques triées
    final generations = pokemons.map((p) => p['generation'] as int).toSet().toList()..sort();

    return ListView(
      children: generations.map((generation) {
        // Filtrer les Pokémon de la génération actuelle
        final pokemonsOfGen = pokemons.where((p) => p['generation'] == generation).toList();

        return ExpansionTile(
          title: Text('Génération $generation'),
          children: pokemonsOfGen.map((pokemon) {
            return ListTile(
              leading: Image.network(
                pokemon['sprites']['regular'],
                width: 50,
                height: 50,
              ),
              title: Text(pokemon['name']['fr']),
              subtitle: Text(pokemon['category']),
              onTap: () {
                // Action quand on appuie sur un Pokémon
              },
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

// pokemon_list_screen.dart
class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  _PokemonListScreenState createState() => _PokemonListScreenState();
}
class _PokemonListScreenState extends State<PokemonListScreen> {
  final TextEditingController _searchController = TextEditingController();

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
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FavoritePokemonsScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un Pokémon...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                context.read<PokemonProvider>().searchPokemons(value);
              },
            ),
          ),
          Expanded(
            child: Consumer<PokemonProvider>(
              builder: (context, provider, child) {
                if (provider.allPokemons.isEmpty) {
                  provider.loadPokemons();
                  return const Center(child: CircularProgressIndicator());
                }

                final pokemonsToDisplay = provider.filteredPokemons.isEmpty
                    ? provider.allPokemons
                    : provider.filteredPokemons;

            // Obtenir la liste unique des générations
            final generations = pokemonsToDisplay
                .map((p) => p.generation)
                .toSet()
                .toList()
              ..sort();

            return ListView(
              children: generations.map((generation) {
                final pokemonsOfGen = pokemonsToDisplay
                    .where((p) => p.generation == generation)
                    .toList();

                return ExpansionTile(
                  title: Text('Génération $generation'),
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: pokemonsOfGen.length,
                      itemBuilder: (context, index) {
                        final pokemon = pokemonsOfGen[index];
                        return PokemonCard(pokemon: pokemon);
                      },
                    ),
                  ],
                );
              }).toList(),
            );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour afficher la fenêtre modale de filtre
  void _showFilterDialog(BuildContext context) {
    final pokemonTypes = [
      {'name': 'normal', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/normal.png'},
      {'name': 'feu', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/feu.png'},
      {'name': 'eau', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/eau.png'},
      {'name': 'plante', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/plante.png'},
      {'name': 'électrik', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/electrik.png'},
      {'name': 'psy', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/psy.png'},
      {'name': 'roche', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/roche.png'},
      {'name': 'sol', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/sol.png'},
      {'name': 'vol', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/vol.png'},
      {'name': 'ténébres', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/tenebres.png'},
      {'name': 'dragon', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/dragon.png'},
      {'name': 'acier', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/acier.png'},
      {'name': 'poison', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/poison.png'},
      {'name': 'combat', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/combat.png'},
      {'name': 'glace', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/glace.png'},
      {'name': 'fée', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/fee.png'},
      {'name': 'insect', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/insecte.png'},
      {'name': 'spectre', 'image': 'https://raw.githubusercontent.com/Yarkis01/TyraDex/images/types/spectre.png'},
    ];

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
                  children: pokemonTypes.map((type) {
                    return CheckboxListTile(
                      title: Row(
                        children: [
                          Image.network(
                            type['image'] ?? '',
                            height: 24,
                            width: 24,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error);
                            },
                          ),
                          SizedBox(width: 8),
                          Text(type['name'] ?? ''),
                        ],
                      ),
                      value: context
                          .watch<PokemonProvider>()
                          .selectedTypes
                          .contains(type['name'] ?? ''),
                      onChanged: (bool? selected) {
                        context
                            .read<PokemonProvider>()
                            .toggleTypeSelection(type['name'] ?? '', selected ?? false);
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
            Consumer<PokemonProvider>(
              builder: (context, provider, _) {
                final isFavorite = provider.favorites.any((fav) => fav.id == pokemon.id);
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite ? Colors.yellow : null,
                  ),
                  onPressed: () {
                    provider.toggleFavorite(pokemon);
                  },
                );
              },
            ),
            Expanded(
              child: Image.network(
                pokemon.sprites,
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[200], // Exemple de couleur de fond
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(
                              type.imageUrl,
                              height: 24,
                              width: 24,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error); // Afficher une icône d'erreur en cas de problème de chargement de l'image
                              },
                            ),
                            SizedBox(width: 8), // Espacement entre l'image et le texte
                            Text(
                              type.name, // Affichage du nom du type
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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

class PokemonDetailScreen extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  // Fonction d'aide pour déterminer quelle URL d'image utiliser
  String _getImageUrl(Pokemon pokemon, bool isShiny, bool isGmax) {
    if (isGmax && pokemon.gmaxSprites != null) {
      return pokemon.gmaxSprites!;
    } else if (isShiny) {
      return pokemon.shinySprites;
    } else {
      return pokemon.sprites;
    }
  }

  bool _isShiny = false;
  bool _isGmax = false;

  @override
  Widget build(BuildContext context) {
    final hasGmax = widget.pokemon.gmaxSprites != null && widget.pokemon.gmaxSprites!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemon.name),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    _getImageUrl(widget.pokemon, _isShiny, _isGmax),
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image, size: 80),
                      );
                    },
                  ),
                ),
                // Bouton shiny
                Positioned(
                  bottom: 16,
                  right: hasGmax ? 76 : 16, // Décalage s'il y a un bouton Gmax
                  child: Material(
                    elevation: 4,
                    shape: const CircleBorder(),
                    color: _isShiny ? Colors.amber : Colors.white,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isShiny = !_isShiny;
                          // Si on active shiny, désactiver Gmax pour éviter la confusion
                          if (_isShiny) _isGmax = false;
                        });
                      },
                      customBorder: const CircleBorder(),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.auto_awesome,
                          color: _isShiny ? Colors.white : Colors.amber,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Bouton Gmax (si disponible)
                if (hasGmax)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Material(
                      elevation: 4,
                      shape: const CircleBorder(),
                      color: _isGmax ? Colors.red : Colors.white,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isGmax = !_isGmax;
                            // Si on active Gmax, désactiver shiny pour éviter la confusion
                            if (_isGmax) _isShiny = false;
                          });
                        },
                        customBorder: const CircleBorder(),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.height,
                            color: _isGmax ? Colors.white : Colors.red,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,  // Couleur neutre pour la catégorie
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.pokemon.category,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Type(s)',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Wrap(
                    spacing: 4,
                    children: widget.pokemon.types.map((type) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(
                              type.imageUrl,
                              height: 34,
                              width: 34,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error); // Afficher une icône d'erreur en cas de problème de chargement de l'image
                              },
                            ),
                            const SizedBox(width: 8), // Espacement entre l'image et le texte
                            Text(
                              type.name, // Affichage du nom du type
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Ligne évolutive",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    children: [
                    _buildEvolutionChain(widget.pokemon),
                    ]   
                  ),
                  const SizedBox(height: 26),
                  Text(
                    'Statistiques',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  StatsWidget(stats: widget.pokemon.stats),
                  const SizedBox(height: 16),
                  Consumer<PokemonProvider>(
                    builder: (context, provider, child) {
                      final isInTeam =
                          provider.playerTeam.pokemons.contains(widget.pokemon);
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isInTeam ? Colors.red : Colors.green,
                          foregroundColor: Colors.white, // Texte en blanc
                        ),
                        onPressed: () {
                          if (isInTeam) {
                            provider.removeFromPlayerTeam(widget.pokemon);
                          } else {
                            provider.addToPlayerTeam(widget.pokemon, context);
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

class FavoritePokemonsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Favoris')),
      body: provider.favorites.isEmpty
          ? Center(child: Text("Aucun Pokémon favori."))
          : ListView.builder(
              itemCount: provider.favorites.length,
              itemBuilder: (context, index) {
                final pokemon = provider.favorites[index];
                return ListTile(
                  leading: Image.network(
                    pokemon.sprites,
                    fit: BoxFit.contain,
                    width: 50,
                    height: 50,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                  title: Text(pokemon.name), // Affichage du nom du Pokémon
                  trailing: IconButton(
                    icon: Icon(Icons.star, color: Colors.yellow),
                    onPressed: () {
                      provider.toggleFavorite(pokemon);
                    },
                  ),
                );
              },
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
            child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            width: 235,
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
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
                  pokemon.sprites,
                  fit: BoxFit.contain,
                ),
              ),
              /*Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  pokemon.name,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),*/
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

// Construction de la ligne évolutive
Widget _buildEvolutionChain(Pokemon pokemon) {
  if (pokemon.evolution == null) {
    return const Text("Pas d'évolution connue");
  }

  List<Widget> evolutionWidgets = [];

  // Afficher les pré-évolutions
  if (pokemon.evolution!.pre != null && pokemon.evolution!.pre!.isNotEmpty) {
    for (var i = 0; i < pokemon.evolution!.pre!.length; i++) {
      evolutionWidgets.add(_buildEvolutionStep(pokemon.evolution!.pre![i]));
      
      // Ajouter une flèche si ce n'est pas le dernier élément
      if (i < pokemon.evolution!.pre!.length - 1) {
        evolutionWidgets.add(_buildArrow());
      }
    }
    // Ajouter une flèche entre pré-évolution et Pokémon actuel
    evolutionWidgets.add(_buildArrow());
  }

  // Ajouter le Pokémon actuel
  evolutionWidgets.add(_buildCurrentPokemon(pokemon));

  // Afficher les évolutions suivantes
  if (pokemon.evolution!.next != null && pokemon.evolution!.next!.isNotEmpty) {
    // Ajouter une flèche entre Pokémon actuel et évolution
    evolutionWidgets.add(_buildArrow());
    
    for (var i = 0; i < pokemon.evolution!.next!.length; i++) {
      evolutionWidgets.add(_buildEvolutionStep(pokemon.evolution!.next![i]));
      
      // Ajouter une flèche si ce n'est pas le dernier élément
      if (i < pokemon.evolution!.next!.length - 1) {
        evolutionWidgets.add(_buildArrow());
      }
    }
  }

  return Wrap(
    alignment: WrapAlignment.center,
    spacing: 8.0,
    runSpacing: 16.0,
    children: evolutionWidgets,
  );
}

Widget _buildArrow() {
  return const Icon(Icons.arrow_forward, color: Colors.grey);
}

Widget _buildEvolutionStep(EvolutionStep step) {
  return InkWell(
    onTap: () {
      // Vous pourriez naviguer vers ce Pokémon ici
      // Navigator.push(context, MaterialPageRoute(builder: (context) => PokemonDetailScreen(id: step.pokedexId)));
    },
    child: Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Vous pourriez ajouter une image ici si disponible
          // Image.network("URL_BASE/${step.pokedexId}.png", height: 60),
          Text(
            step.name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              step.condition,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildCurrentPokemon(Pokemon pokemon) {
  return Container(
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: Colors.blue.shade300),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Vous pouvez utiliser l'image existante
        Image.network(pokemon.sprites, height: 70),
        const SizedBox(height: 4),
        Text(
          pokemon.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text(
          "Forme actuelle",
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
      ],
    ),
  );
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
