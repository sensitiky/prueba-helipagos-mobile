import 'package:equatable/equatable.dart';

abstract class CoinEvent extends Equatable {
  const CoinEvent();

  @override
  List<Object> get props => [];
}

class FetchCoins extends CoinEvent {
  final bool refresh;

  const FetchCoins({this.refresh = false});

  @override
  List<Object> get props => [refresh];
}

class SearchCoins extends CoinEvent {
  final String query;

  const SearchCoins(this.query);

  @override
  List<Object> get props => [query];
}
