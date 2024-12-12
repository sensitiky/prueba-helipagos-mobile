import 'package:json_annotation/json_annotation.dart';

part 'flspot.g.dart';

//This class isnt useful stays just in case to make a chart for the coins
@JsonSerializable()
class CoinDetail {
  final String id;
  final String symbol;
  final String name;
  final String image;

  @JsonKey(name: 'current_price')
  final double currentPrice;

  @JsonKey(name: 'market_cap')
  final double marketCap;

  @JsonKey(name: 'market_cap_rank')
  final int marketCapRank;

  @JsonKey(name: 'fully_diluted_valuation')
  final double? fullyDilutedValuation;

  @JsonKey(name: 'total_volume')
  final double totalVolume;

  @JsonKey(name: 'high_24h')
  final double high24h;

  @JsonKey(name: 'low_24h')
  final double low24h;

  @JsonKey(name: 'price_change_24h')
  final double priceChange24h;

  @JsonKey(name: 'price_change_percentage_24h')
  final double priceChangePercentage24h;

  @JsonKey(name: 'market_cap_change_24h')
  final double marketCapChange24h;

  @JsonKey(name: 'market_cap_change_percentage_24h')
  final double marketCapChangePercentage24h;

  @JsonKey(name: 'circulating_supply')
  final double circulatingSupply;

  @JsonKey(name: 'total_supply')
  final double? totalSupply;

  @JsonKey(name: 'max_supply')
  final double? maxSupply;

  final double ath;

  @JsonKey(name: 'ath_change_percentage')
  final double athChangePercentage;

  @JsonKey(name: 'ath_date')
  final DateTime athDate;

  final double atl;

  @JsonKey(name: 'atl_change_percentage')
  final double atlChangePercentage;

  @JsonKey(name: 'atl_date')
  final DateTime atlDate;

  final dynamic roi;

  @JsonKey(name: 'last_updated')
  final DateTime lastUpdated;

  CoinDetail({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    this.fullyDilutedValuation,
    required this.totalVolume,
    required this.high24h,
    required this.low24h,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.marketCapChange24h,
    required this.marketCapChangePercentage24h,
    required this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    required this.ath,
    required this.athChangePercentage,
    required this.athDate,
    required this.atl,
    required this.atlChangePercentage,
    required this.atlDate,
    this.roi,
    required this.lastUpdated,
  });

  factory CoinDetail.fromJson(Map<String, dynamic> json) =>
      _$CoinDetailFromJson(json);

  Map<String, dynamic> toJson() => _$CoinDetailToJson(this);
}
