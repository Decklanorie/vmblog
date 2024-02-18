import 'package:graphql/client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GraphQLClientService {
  GraphQLClient getClient() {
    final Link link = HttpLink('https://uat-api.vmodel.app/graphql/');
    return GraphQLClient(link: link, cache: GraphQLCache());
  }
}