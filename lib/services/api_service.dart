import 'dart:convert';
import 'package:prueba_helipagos_mobile/models/coin.dart';
import 'package:http/http.dart' as http;
import 'package:prueba_helipagos_mobile/models/nft.dart';

class ApiService {
  final String baseUrl = "https://api.coingecko.com/api/v3";
  final String apiKey = "CG-U9S4KQMw5EqVq52GthUdMjMU";

  final Map<String, String> _nftImageCache = {};

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
        Uri.parse("$baseUrl/search?query=$query&x-cg-demo-api-key=$apiKey"));
    if (searchResponse.statusCode == 200) {
      Map<String, dynamic> searchData = json.decode(searchResponse.body);
      List<dynamic> coins = searchData['coins'];
      List<String> coinIds =
          coins.map<String>((coin) => coin['id'] as String).toList();

      if (coinIds.isEmpty) {
        return [];
      }

      final coinsDataResponse = await http.get(Uri.parse(
          "$baseUrl/coins/markets?vs_currency=usd&ids=${coinIds.join(',')}&order=market_cap_desc&per_page=${coinIds.length}&page=1&sparkline=false&x-cg-demo-api-key=$apiKey"));
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
      Uri.parse("$baseUrl/nfts/list?x-cg-demo-api-key=$apiKey"),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Nft> nfts = data.map((nft) => Nft.fromJson(nft)).toList();
      return nfts;
    } else {
      throw Exception("Error al cargar los NFTs");
    }
  }

  Future<Nft> fetchNftDetails(
      String assetPlatformId, String contractAddress) async {
    final cacheKey = "$assetPlatformId-$contractAddress";

    if (_nftImageCache.containsKey(cacheKey)) {
      return Nft(
        assetPlatformId: assetPlatformId,
        contractAddress: contractAddress,
      );
    }

    final url =
        "$baseUrl/nfts/$assetPlatformId/contract/$contractAddress?x-cg-demo-api-key=$apiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      final nft = Nft.fromJson(data);

      return nft;
    } else if (response.statusCode == 429) {
      throw Exception(
          "Has excedido el límite de solicitudes. Por favor, intenta de nuevo más tarde.");
    } else {
      throw Exception("Error al obtener los detalles del NFT");
    }
  }
}
