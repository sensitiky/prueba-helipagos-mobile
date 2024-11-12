import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/coin_bloc.dart';
import '../events/coin_event.dart';
import '../states/coin_state.dart';
import '../models/coin.dart';
import 'dart:async';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (value.isNotEmpty) {
        BlocProvider.of<CoinBloc>(context).add(SearchCoins(value));
      } else {
        BlocProvider.of<CoinBloc>(context).add(const FetchCoins(refresh: true));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Monedas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Buscar moneda...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: BlocBuilder<CoinBloc, CoinState>(
              builder: (context, state) {
                if (state is CoinLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CoinLoaded) {
                  final coins = state.coins;
                  if (coins.isEmpty) {
                    return const Center(child: Text('Moneda no disponible'));
                  }
                  return ListView.builder(
                    itemCount: coins.length,
                    itemBuilder: (context, index) {
                      final Coin coin = coins[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: ListTile(
                          leading: coin.imageUrl != null
                              ? Image.network(
                                  coin.imageUrl!,
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.monetization_on),
                                )
                              : CircleAvatar(
                                  child: Text(coin.symbol
                                      .substring(0, 1)
                                      .toUpperCase()),
                                ),
                          title: Text(coin.name),
                          subtitle:
                              Text('Símbolo: ${coin.symbol.toUpperCase()}'),
                          trailing: coin.currentPrice != null
                              ? Text(
                                  '\$${coin.currentPrice!.toStringAsFixed(2)}')
                              : const Text('N/A'),
                          onTap: () {
                            Navigator.pushNamed(context, '/coin_detail',
                                arguments: coin);
                          },
                        ),
                      );
                    },
                  );
                } else if (state is CoinError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(
                      child: Text('Ingresa un término de búsqueda'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
