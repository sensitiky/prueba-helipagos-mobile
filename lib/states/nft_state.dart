import 'package:equatable/equatable.dart';
import '../models/nft.dart';

abstract class NftState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NftInitial extends NftState {}

class NftLoading extends NftState {}

class NftLoaded extends NftState {
  final List<Nft> nfts;

  NftLoaded(this.nfts);

  @override
  List<Object?> get props => [nfts];
}

class NftError extends NftState {
  final String message;

  NftError(this.message);

  @override
  List<Object?> get props => [message];
}
