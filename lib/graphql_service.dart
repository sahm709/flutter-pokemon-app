import 'package:graphql/client.dart';
import 'package:pokemon_app/graphql_config.dart';
import 'package:pokemon_app/pokemon_model.dart';

class GraphQLService {
  static GraphQLConfig graphQLConfig = GraphQLConfig();

  GraphQLClient client = graphQLConfig.clientToQuery();

  Future<List<PokemonModel>> getPokemons({required int first}) async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
           query pokemons(\$first: Int!) {
              pokemons(first: \$first) {
                id
                number
                name
                height {
                  minimum
                  maximum
                }
                weight {
                  minimum
                  maximum
                }
                classification
                types
                resistant
                weaknesses
                fleeRate
                maxCP
                maxHP
                image
              }
            }
            """),
          variables: {
            'first': first,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        List? res = result.data?['pokemons'];

        if (res == null || res.isEmpty) {
          return [];
        }

        List<PokemonModel> pokemons =
        res.map((pokemon) => PokemonModel.fromMap(map: pokemon)).toList();

        return pokemons;
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<PokemonModel?> getPokemonDetails({required String id}) async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
            query pokemon(\$id: String!) {
              pokemon(id: \$id) {
                id
                number
                name
                height {
                  minimum
                  maximum
                }
                weight {
                  minimum
                  maximum
                }
                classification
                types
                resistant
                weaknesses
                fleeRate
                maxCP
                maxHP
                image
                evolutions {
                  id
                  number
                  name
                  types
                  image 
                }
              }
            }
          """),
          variables: {'id': id},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        Map<String, dynamic>? res = result.data?['pokemon'];
        if (res == null) return null;
        return PokemonModel.fromMap(map: res);
      }
    } catch (error) {
      throw Exception(error);
    }
  }
}
