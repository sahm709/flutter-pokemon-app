class PokemonModel {
  final String id;
  final String number;
  final String name;
  final String classification;
  final List<String> types;
  final List<String> resistant;
  final List<String> weaknesses;
  final double fleeRate;
  final int maxCP;
  final int maxHP;
  final String image;
  final String height;
  final String weight;

  PokemonModel({
    required this.id,
    required this.number,
    required this.name,
    required this.classification,
    required this.types,
    required this.resistant,
    required this.weaknesses,
    required this.fleeRate,
    required this.maxCP,
    required this.maxHP,
    required this.image,
    required this.height,
    required this.weight,
  });

  factory PokemonModel.fromMap({required Map<String, dynamic> map}) {
    return PokemonModel(
      id: map['id'],
      number: map['number'],
      name: map['name'],
      classification: map['classification'],
      types: List<String>.from(map['types']),
      resistant: List<String>.from(map['resistant']),
      weaknesses: List<String>.from(map['weaknesses']),
      fleeRate: (map['fleeRate'] as num).toDouble(),
      maxCP: map['maxCP'],
      maxHP: map['maxHP'],
      image: map['image'],
      height: "${map['height']['minimum']} - ${map['height']['maximum']}",
      weight: "${map['weight']['minimum']} - ${map['weight']['maximum']}",
    );
  }
}
