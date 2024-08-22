import 'package:graphql/client.dart';

class GraphQLConfig {
  static HttpLink httpLink = HttpLink('https://graphql-pokemon2.vercel.app');

  GraphQLClient clientToQuery() =>
      GraphQLClient(link: httpLink, cache: GraphQLCache());
}