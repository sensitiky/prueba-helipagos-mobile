import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';
import '../events/nft_event.dart';
import '../states/nft_state.dart';

class NftBloc extends Bloc<NftEvent, NftState> {
  final ApiService apiService;

  NftBloc(this.apiService) : super(NftInitial()) {
    on<FetchNfts>(_onFetchNfts);
  }

  Future<void> _onFetchNfts(FetchNfts event, Emitter<NftState> emit) async {
    emit(NftLoading());
    try {
      final nfts = await apiService.fetchNfts();
      if (nfts.isEmpty) {
        emit(NftError("No se encontraron NFTs"));
      } else {
        emit(NftLoaded(nfts));
      }
    } catch (e) {
      emit(NftError(e.toString()));
    }
  }
}
