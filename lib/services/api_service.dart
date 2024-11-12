import 'dart:convert';
import 'package:prueba_helipagos_mobile/models/coin.dart';
import 'package:http/http.dart' as http;
import 'package:prueba_helipagos_mobile/models/nft.dart';

class ApiService {
  final String baseUrl = "https://api.coingecko.com/api/v3";
  final String apiKey = "CG-U9S4KQMw5EqVq52GthUdMjMU";

  Future<List<Coin>> fetchCoins({int page = 1, int perPage = 10}) async {
    final response = await http.get(Uri.parse(
        "$baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$perPage&page=$page&sparkline=false&x_cg_demo_api_key=$apiKey"));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((coin) => Coin.fromJson(coin)).toList();
    } else {
      throw Exception("Error al cargar las monedas");
    }
  }

  Future<List<Coin>> searchCoins(String query) async {
    final searchResponse = await http.get(
        Uri.parse("$baseUrl/search?query=$query&x_cg_demo_api_key=$apiKey"));
    if (searchResponse.statusCode == 200) {
      Map<String, dynamic> searchData = json.decode(searchResponse.body);
      List<dynamic> coins = searchData['coins'];
      List<String> coinIds =
          coins.map<String>((coin) => coin['id'] as String).toList();

      if (coinIds.isEmpty) {
        return [];
      }

      final coinsDataResponse = await http.get(Uri.parse(
          "$baseUrl/coins/markets?vs_currency=usd&ids=${coinIds.join(',')}&order=market_cap_desc&per_page=${coinIds.length}&page=1&sparkline=false&x_cg_demo_api_key=$apiKey"));
      if (coinsDataResponse.statusCode == 200) {
        List<dynamic> coinsData = json.decode(coinsDataResponse.body);
        return coinsData.map((coin) => Coin.fromJson(coin)).toList();
      } else {
        throw Exception("Error al obtener detalles de monedas");
      }
    } else {
      throw Exception("Error al buscar monedas");
    }
  }

  Future<List<Nft>> fetchNfts() async {
    final response = await http.get(
      Uri.parse("$baseUrl/nfts/list?x_cg_demo_api_key=$apiKey"),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((nft) => Nft.fromJson(nft)).toList();
    } else {
      throw Exception("Error al cargar los NFTs");
    }
  }
}
