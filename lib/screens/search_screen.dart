import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';
import 'dart:ui';
import 'package:prueba_helipagos_mobile/blocs/coin_bloc.dart';
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

class CoinCard extends StatelessWidget {
  final Coin coin;

  const CoinCard({required this.coin, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (coin.imageUrl != null)
                Image.network(
                  coin.imageUrl!,
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.monetization_on, size: 50),
                )
              else
                const Icon(Icons.monetization_on, size: 50),
              const SizedBox(height: 8),
              Text(
                coin.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                coin.symbol.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade300,
                ),
              ),
              const SizedBox(height: 8),
              // Precio actual
              coin.currentPrice != null
                  ? Text(
                      '\$${coin.currentPrice!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'N/A',
                      style: TextStyle(color: Colors.white),
                    ),
              if (coin.priceChange != null)
                Text(
                  '${coin.priceChange! >= 0 ? '+' : ''}${coin.priceChange!.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: coin.priceChange! >= 0
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
