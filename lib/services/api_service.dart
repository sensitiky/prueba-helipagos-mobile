import 'dart:convert';
import 'package:prueba_helipagos_mobile/models/coin.dart';
import 'package:http/http.dart' as http;
import 'package:prueba_helipagos_mobile/models/env.dart';
import 'package:prueba_helipagos_mobile/models/nft.dart';

class ApiService {
  final String baseUrl = Env.baseUrl;
  final String apiKey = Env.apiKey;
  final Map<String, List<Coin>> _coinCache = {};
  final Map<String, Nft> _nftCache = {};
  final Map<String, List<Coin>> _searchCoinsCache = {};
  final Map<String, List<Nft>> _nftListCache = {};

  Future<List<Coin>> fetchCoins({int page = 1, int perPage = 10}) async {
    final cacheKey = "page_$page$perPage";
    if (_coinCache.containsKey(cacheKey)) {
      return _coinCache[cacheKey]!;
    }
    try {
      final response = await http.get(Uri.parse(
          "$baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$perPage&page=$page&sparkline=false&x_cg_demo_api_key=$apiKey"));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Coin> coins = data.map((coin) => Coin.fromJson(coin)).toList();
        _coinCache[cacheKey] = coins;
        return coins;
      } else {
        throw Exception("Error al cargar las monedas");
      }
    } catch (error) {
      throw Exception("Error al ejecutar la operación $error");
    }
  }

  Future<List<Coin>> searchCoins(String query) async {
    if (_searchCoinsCache.containsKey(query)) {
      return _searchCoinsCache[query]!;
    }

    try {
      final searchResponse = await http.get(
          Uri.parse("$baseUrl/search?query=$query&x-cg-demo-api-key=$apiKey"));
      if (searchResponse.statusCode == 200) {
        Map<String, dynamic> searchData = json.decode(searchResponse.body);
        List<dynamic> coins = searchData['coins'];
        List<String> coinIds =
            coins.map<String>((coin) => coin['id'] as String).toList();

        if (coinIds.isEmpty) {
          _searchCoinsCache[query] = [];
          return [];
        }
        final coinsDataResponse = await http.get(Uri.parse(
            "$baseUrl/coins/markets?vs_currency=usd&ids=${coinIds.join(',')}&order=market_cap_desc&per_page=${coinIds.length}&page=1&sparkline=false&x-cg-demo-api-key=$apiKey"));
        if (coinsDataResponse.statusCode == 200) {
          List<dynamic> coinsData = json.decode(coinsDataResponse.body);
          List<Coin> coinsList =
              coinsData.map((coin) => Coin.fromJson(coin)).toList();
          _searchCoinsCache[query] = coinsList;
          return coinsList;
        } else {
          throw Exception("Error al obtener detalles de monedas");
        }
      } else if (searchResponse.statusCode == 429) {
        throw Exception(
            "Has excedido el límite de solicitudes. Por favor, intenta de nuevo más tarde.");
      } else {
        throw Exception("Error al realizar la búsqueda.");
      }
    } catch (error) {
      throw Exception("Error al buscar coins $error");
    }
  }

  Future<List<Nft>> fetchNfts({int page = 1, int perPage = 10}) async {
    final cacheKey = "page_$page$perPage";
    if (_nftListCache.containsKey(cacheKey)) {
      return _nftListCache[cacheKey]!;
    }
    try {
      final response = await http.get(
        Uri.parse(
            "$baseUrl/nfts/list?per_page=$perPage&page=$page&x-cg-demo-api-key=$apiKey"),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Nft> nfts = data.map((nft) => Nft.fromJson(nft)).toList();
        _nftListCache[cacheKey] = nfts;
        return nfts;
      } else {
        throw Exception("Error al cargar los NFTs");
      }
    } catch (error) {
      throw Exception("Error al cargar los NFTs $error");
    }
  }

  Future<Nft> fetchNftDetails(
      String assetPlatformId, String contractAddress) async {
    final cacheKey = "$assetPlatformId-$contractAddress";

    if (_nftCache.containsKey(cacheKey)) {
      return _nftCache[cacheKey]!;
    }

    try {
      final url =
          "$baseUrl/nfts/$assetPlatformId/contract/$contractAddress?x-cg-demo-api-key=$apiKey";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        final nft = Nft.fromJson(data);
        _nftCache[cacheKey] = nft;
        return nft;
      } else if (response.statusCode == 429) {
        throw Exception(
            "Has excedido el límite de solicitudes. Por favor, intenta de nuevo más tarde.");
      } else {
        throw Exception("Error al obtener los detalles del NFT");
      }
    } catch (error) {
      throw Exception("Error al obtener los detalles del NFT $error");
    }
  }
}
