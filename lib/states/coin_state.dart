import 'package:equatable/equatable.dart';
import 'package:prueba_helipagos_mobile/models/coin.dart';

abstract class CoinState extends Equatable {
  const CoinState();

  @override
  List<Object> get props => [];
}

class CoinInitial extends CoinState {}

class CoinLoading extends CoinState {}

class CoinLoaded extends CoinState {
  final List<Coin> coins;
  final bool hasReachedMax;

  const CoinLoaded({required this.coins, required this.hasReachedMax});

  CoinLoaded copyWith({
    List<Coin>? coins,
    bool? hasReachedMax,
  }) {
    return CoinLoaded(
      coins: coins ?? this.coins,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [coins, hasReachedMax];
}

class CoinError extends CoinState {
  final String message;

  const CoinError({required this.message});

  @override
  List<Object> get props => [message];
}
