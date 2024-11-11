import 'package:json_annotation/json_annotation.dart';

part 'nft.g.dart';

@JsonSerializable()
class Nft {
  final String id;
  final String name;
  @JsonKey(name: 'contract_address')
  final String contractAddress;
  @JsonKey(name: 'asset_platform_id')
  final String assetPlatformId;

  Nft({
    required this.id,
    required this.name,
    required this.contractAddress,
    required this.assetPlatformId,
  });

  factory Nft.fromJson(Map<String, dynamic> json) => _$NftFromJson(json);
  Map<String, dynamic> toJson() => _$NftToJson(this);
}
