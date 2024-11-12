import 'package:json_annotation/json_annotation.dart';

part "coin.g.dart";

@JsonSerializable()
class Coin {
  final String id;
  final String symbol;
  final String name;

  @JsonKey(name: 'image')
  final String? imageUrl;

  @JsonKey(name: 'current_price')
  final double? currentPrice;
  @JsonKey(name: 'price_change_percentage_24h')
  final double? priceChange;

  Coin(
      {required this.id,
      required this.symbol,
      required this.name,
      this.imageUrl,
      this.currentPrice,
      this.priceChange});

  factory Coin.fromJson(Map<String, dynamic> json) => _$CoinFromJson(json);

  Map<String, dynamic> toJson() => _$CoinToJson(this);
}
