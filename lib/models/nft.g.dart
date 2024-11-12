// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Nft _$NftFromJson(Map<String, dynamic> json) => Nft(
      id: json['id'] as String?,
      name: json['name'] as String?,
      contractAddress: json['contract_address'] as String?,
      assetPlatformId: json['asset_platform_id'] as String?,
      bannerImage: json['banner_image'] as String?,
      description: json['description'] as String?,
      nativeCurrency: json['native_currency'] as String?,
      nativeCurrencySymbol: json['native_currency_symbol'] as String?,
    );

Map<String, dynamic> _$NftToJson(Nft instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'contract_address': instance.contractAddress,
      'asset_platform_id': instance.assetPlatformId,
      'banner_image': instance.bannerImage,
      'description': instance.description,
      'native_currency': instance.nativeCurrency,
      'native_currency_symbol': instance.nativeCurrencySymbol,
    };
