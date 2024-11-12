// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Nft _$NftFromJson(Map<String, dynamic> json) => Nft(
      name: json['name'] as String?,
      contractAddress: json['contract_address'] as String?,
      assetPlatformId: json['asset_platform_id'] as String?,
    );

Map<String, dynamic> _$NftToJson(Nft instance) => <String, dynamic>{
      'name': instance.name,
      'contract_address': instance.contractAddress,
      'asset_platform_id': instance.assetPlatformId,
    };
