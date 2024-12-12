import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';
import 'package:prueba_helipagos_mobile/blocs/coin_bloc.dart';
import 'package:prueba_helipagos_mobile/components/coin_card.dart';
import 'package:prueba_helipagos_mobile/events/coin_event.dart';
import 'package:prueba_helipagos_mobile/models/coin.dart';
import 'package:prueba_helipagos_mobile/states/coin_state.dart';

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
        centerTitle: true,
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
                  return RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<CoinBloc>(context)
                          .add(const FetchCoins(refresh: true));
                    },
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      padding: const EdgeInsets.all(8),
                      itemCount: coins.length,
                      itemBuilder: (context, index) {
                        final Coin coin = coins[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/coin_detail',
                                arguments: coin);
                          },
                          child: CoinCard(coin: coin),
                        );
                      },
                    ),
                  );
                } else if (state is CoinError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
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
