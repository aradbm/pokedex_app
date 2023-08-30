import 'package:http/http.dart' as http;

class PokeAPI {
  static Future<http.Response> getPokemon() => http.get(
        Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=100"),
      );
  static Future<http.Response> getPokemonDetails(int id) => http.get(
        Uri.parse("https://pokeapi.co/api/v2/pokemon/$id"),
      );
}
