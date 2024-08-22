import 'package:flutter/material.dart';
import 'package:pokemon_app/graphql_service.dart';
import 'package:pokemon_app/pokemon_model.dart';
import 'package:pokemon_app/pokemon_detail_page.dart';
import 'dart:developer';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Poke App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<PokemonModel> _pokemons = [];
  List<PokemonModel> _filteredPokemons = [];
  final GraphQLService _graphQLService = GraphQLService();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _currentPage = 1;
  final int _limit = 1000;
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _loadMorePokemons();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _loadMorePokemons();
    }
  }

  Future<void> _loadMorePokemons() async {
    setState(() => _isLoading = true);

    try {
      List<PokemonModel> fetchedPokemons = await _graphQLService.getPokemons(
        first: _currentPage * _limit,
      );
      final newPokemons = fetchedPokemons.skip(_pokemons.length).toList();

      if (newPokemons.isNotEmpty) {
        setState(() {
          _pokemons.addAll(newPokemons);
          _applyFilter();
          _currentPage++;
        });
      }
    } catch (error) {
      log('Error loading Pokémon: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterPokemonsByType(String? type) {
    setState(() {
      _selectedType = type;
      _applyFilter();
    });
  }

  void _applyFilter() {
    if (_selectedType == null || _selectedType!.isEmpty) {
      _filteredPokemons = _pokemons;
    } else {
      _filteredPokemons = _pokemons.where((pokemon) => pokemon.types.contains(_selectedType)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Poke App"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          DropdownButton<String>(
            hint: const Text('Filter by Type'),
            value: _selectedType,
            onChanged: _filterPokemonsByType,
            items: <String>[
              'All',
              'Grass',
              'Fire',
              'Water',
              'Poison',
              'Electric',
              'Bug',
              'Flying',
              'Rock',
              'Ground',
              'Psychic',
              'Ice',
              'Dragon',
              'Steel',
              'Fairy'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value == 'All' ? null : value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: _filteredPokemons.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        itemCount: _filteredPokemons.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _filteredPokemons.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final pokemon = _filteredPokemons[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PokemonDetailPage(pokemon: pokemon),
                ),
              );
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    pokemon.image,
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pokemon.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: pokemon.types.map((type) => _buildTypePill(type)).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypePill(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getTypeColor(type),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        type,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return Colors.green;
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'poison':
        return Colors.purple;
      case 'electric':
        return Colors.yellow;
      case 'bug':
        return Colors.lightGreen;
      case 'flying':
        return Colors.lightBlue;
      case 'rock':
        return Colors.brown;
      case 'ground':
        return Colors.orange;
      case 'psychic':
        return Colors.pink;
      case 'ice':
        return Colors.cyan;
      case 'dragon':
        return Colors.indigo;
      case 'steel':
        return Colors.grey;
      case 'fairy':
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }
}
