import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_helipagos_mobile/blocs/coin_bloc.dart';
import 'package:prueba_helipagos_mobile/events/coin_event.dart';
import 'package:prueba_helipagos_mobile/main.dart';
import 'package:prueba_helipagos_mobile/models/coin.dart';
import 'package:prueba_helipagos_mobile/states/coin_state.dart';
import 'dart:ui';

class CoinListScreen extends StatefulWidget {
  const CoinListScreen({super.key});

  @override
  CoinListScreenState createState() => CoinListScreenState();
}

class CoinListScreenState extends State<CoinListScreen> {
  final ScrollController _scrollController = ScrollController();
  late CoinBloc _coinBloc;

  CoinFilter _selectedFilter = CoinFilter.all;

  @override
  void initState() {
    super.initState();
    _coinBloc = BlocProvider.of<CoinBloc>(context);
    _coinBloc.add(const FetchCoins());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_coinBloc.isFetching) {
        final state = _coinBloc.state;
        if (state is CoinLoaded && !state.hasReachedMax) {
          _coinBloc.add(const FetchCoins());
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Coin> _applyFilter(List<Coin> coins) {
    switch (_selectedFilter) {
      case CoinFilter.topGainers:
        coins
            .sort((a, b) => (b.priceChange ?? 0).compareTo(a.priceChange ?? 0));
        break;
      case CoinFilter.topLosers:
        coins
            .sort((a, b) => (a.priceChange ?? 0).compareTo(b.priceChange ?? 0));
        break;
      case CoinFilter.all:
      default:
        break;
    }
    return coins;
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Todas'),
                onTap: () {
                  setState(() {
                    _selectedFilter = CoinFilter.all;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Top Aumentos'),
                onTap: () {
                  setState(() {
                    _selectedFilter = CoinFilter.topGainers;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Top Descensos'),
                onTap: () {
                  setState(() {
                    _selectedFilter = CoinFilter.topLosers;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleTheme() {
    mainAppKey.currentState?.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'search_fab',
            backgroundColor: Colors.blue[900],
            onPressed: () {
              Navigator.pushNamed(context, "/search");
            },
            child: const Icon(Icons.search, color: Colors.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'filter_fab',
            backgroundColor: Colors.blue[900],
            onPressed: () {
              _showFilterOptions();
            },
            child: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('Mercado Crypto'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: BlocBuilder<CoinBloc, CoinState>(
        builder: (context, state) {
          if (state is CoinLoading && _coinBloc.currentPage == 1) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CoinLoaded) {
            final List<Coin> filteredCoins =
                _applyFilter(List.from(state.coins));

            return RefreshIndicator(
              onRefresh: () async {
                _coinBloc.currentPage = 1;
                _coinBloc.add(const FetchCoins(refresh: true));
              },
              child: ListView.builder(
                key: const Key("coinList"),
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                itemCount: state.hasReachedMax
                    ? filteredCoins.length
                    : filteredCoins.length + 1,
                itemBuilder: (context, index) {
                  if (index >= filteredCoins.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final Coin coin = filteredCoins[index];
                  return GestureDetector(
                    key: Key("coinItem_$index"),
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
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class CoinCard extends StatelessWidget {
  final Coin coin;

  const CoinCard({required this.coin, super.key});

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.2)
        : Colors.black.withOpacity(0.2);

    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.15)
        : Colors.black12;

    final changePriceColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.greenAccent
        : const Color(0xFF2D7130);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
            ),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
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
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Column(
                        children: [
                          Text(
                            coin.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            coin.symbol.toUpperCase(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        coin.currentPrice != null
                            ? Text(
                                '\$${coin.currentPrice!.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
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
                                  ? changePriceColor
                                  : Colors.redAccent,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum CoinFilter { all, topGainers, topLosers }
