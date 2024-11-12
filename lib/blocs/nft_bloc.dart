import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_helipagos_mobile/events/nft_event.dart';
import 'package:prueba_helipagos_mobile/services/api_service.dart';
import 'package:prueba_helipagos_mobile/states/nft_state.dart';

class NftBloc extends Bloc<NftEvent, NftState> {
  final ApiService apiService;
  int currentPage = 1;
  bool isFetching = false;
  NftBloc(this.apiService) : super(NftInitial()) {
    on<FetchNfts>(_onFetchNfts);
  }

  Future<void> _onFetchNfts(FetchNfts event, Emitter<NftState> emit) async {
    if (isFetching) return;
    isFetching = true;
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
    } finally {
      isFetching = false;
    }
  }
}
