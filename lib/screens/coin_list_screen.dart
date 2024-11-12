import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../events/coin_event.dart';
import '../blocs/coin_bloc.dart';
import '../states/coin_state.dart';
import '../models/coin.dart';

class CoinsListScreen extends StatefulWidget {
  const CoinsListScreen({super.key});

  @override
  CoinsListScreenState createState() => CoinsListScreenState();
}

class CoinsListScreenState extends State<CoinsListScreen> {
  final ScrollController _scrollController = ScrollController();
  late CoinBloc _coinBloc;

  @override
  void initState() {
    super.initState();
    _coinBloc = BlocProvider.of<CoinBloc>(context);
    _coinBloc.add(const FetchCoins());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_coinBloc.isFetching &&
          !_coinBloc.state.props.contains(true)) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Lista de Monedas'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/search");
        },
        child: const Icon(Icons.search),
      ),
      body: BlocBuilder<CoinBloc, CoinState>(
        builder: (context, state) {
          if (state is CoinLoading && _coinBloc.currentPage == 1) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CoinLoaded) {
            final coins = state.coins;
            return RefreshIndicator(
              onRefresh: () async {
                _coinBloc.currentPage = 1;
                _coinBloc.add(const FetchCoins(refresh: true));
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount:
                    state.hasReachedMax ? coins.length : coins.length + 1,
                itemBuilder: (context, index) {
                  if (index >= coins.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final Coin coin = coins[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                              child: Text(
                                  coin.symbol.substring(0, 1).toUpperCase()),
                            ),
                      title: Text(coin.name),
                      subtitle: Text('Símbolo: ${coin.symbol.toUpperCase()}'),
                      trailing: coin.currentPrice != null
                          ? Text('\$${coin.currentPrice!.toStringAsFixed(2)}')
                          : const Text('N/A'),
                      onTap: () {
                        Navigator.pushNamed(context, '/coin_detail',
                            arguments: coin);
                      },
                    ),
                  );
                },
              ),
            );
          } else if (state is CoinError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
