import 'package:prueba_helipagos_mobile/models/nft.dart';

abstract class NftState {
  const NftState();
}

class NftLoading extends NftState {}

class NftLoaded extends NftState {
  final List<Nft> nfts;
  final bool hasReachedMax;

  const NftLoaded({required this.nfts, required this.hasReachedMax});

  NftLoaded copyWith({List<Nft>? nfts, bool? hasReachedMax}) {
    return NftLoaded(
      nfts: nfts ?? this.nfts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class NftError extends NftState {
  final String message;
  const NftError({required this.message});
}
