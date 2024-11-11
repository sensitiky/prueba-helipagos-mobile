import 'package:equatable/equatable.dart';

abstract class NftEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNfts extends NftEvent {}
