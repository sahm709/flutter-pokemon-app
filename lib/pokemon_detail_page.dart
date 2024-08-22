import 'package:flutter/material.dart';
import 'package:pokemon_app/pokemon_model.dart';

class PokemonDetailPage extends StatelessWidget {
  final PokemonModel pokemon;

  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
      ),
      body: Container(
        color: _getTypeColor(pokemon.types[0]),
        child: Stack(
          children: [
            Positioned(
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width - 20,
              left: 10.0,
              top: MediaQuery.of(context).size.height * 0.1 ,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15.0),
                      Text(
                        pokemon.name,
                        style: const TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16.0),
                      Text("Height: ${pokemon.height}"),
                      const SizedBox(height: 8.0),
                      Text("Weight: ${pokemon.weight}"),
                      const SizedBox(height: 16.0),
                      const Text(
                        "Types",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        alignment: WrapAlignment.center,
                        children: pokemon.types
                            .map((type) => Chip(
                          backgroundColor: _getTypeColor(type),
                          label: Text(
                            type,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ))
                            .toList(),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        "Weaknesses",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        alignment: WrapAlignment.center,
                        children: pokemon.weaknesses
                            .map((weakness) => Chip(
                          backgroundColor: _getTypeColor(weakness),
                          label: Text(
                            weakness,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Hero(
                tag: pokemon.image,
                child: Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.075),
                  height: 200.0,
                  width: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(pokemon.image),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
