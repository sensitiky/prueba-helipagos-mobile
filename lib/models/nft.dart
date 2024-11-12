import 'package:json_annotation/json_annotation.dart';

part 'nft.g.dart';

@JsonSerializable()
class Nft {
  final String? id;
  final String? name;
  @JsonKey(name: 'contract_address')
  final String? contractAddress;
  @JsonKey(name: 'asset_platform_id')
  final String? assetPlatformId;
  @JsonKey(name: 'banner_image')
  final String? bannerImage;
  final String? description;
  @JsonKey(name: "native_currency")
  final String? nativeCurrency;
  @JsonKey(name: 'native_currency_symbol')
  final String? nativeCurrencySymbol;

  Nft({
    this.id,
    this.name,
    this.contractAddress,
    this.assetPlatformId,
    this.bannerImage,
    this.description,
    this.nativeCurrency,
    this.nativeCurrencySymbol,
  });

  factory Nft.fromJson(Map<String, dynamic> json) => _$NftFromJson(json);

  Map<String, dynamic> toJson() => _$NftToJson(this);
}
