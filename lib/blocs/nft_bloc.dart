import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_helipagos_mobile/events/nft_event.dart';
import 'package:prueba_helipagos_mobile/models/nft.dart';
import 'package:prueba_helipagos_mobile/services/api_service.dart';
import 'package:prueba_helipagos_mobile/states/nft_state.dart';

class NftBloc extends Bloc<NftEvent, NftState> {
  final ApiService apiService;
  int currentPage = 1;
  bool isFetching = false;

  NftBloc({required this.apiService}) : super(NftLoading()) {
    on<FetchNfts>((event, emit) async {
      emit(NftLoading());
      try {
        final nfts = await apiService.fetchNfts(page: currentPage);
        emit(NftLoaded(nfts: nfts, hasReachedMax: nfts.isEmpty));
      } catch (e) {
        emit(NftError(message: e.toString()));
      }
    });

    on<FetchMoreNfts>((event, emit) async {
      if (state is NftLoaded &&
          !(state as NftLoaded).hasReachedMax &&
          !isFetching) {
        isFetching = true;
        currentPage++;
        try {
          final nfts = await apiService.fetchNfts(page: currentPage);
          if (nfts.isEmpty) {
            emit((state as NftLoaded).copyWith(hasReachedMax: true));
          } else {
            final updatedNfts = List<Nft>.from((state as NftLoaded).nfts)
              ..addAll(nfts);
            emit(NftLoaded(nfts: updatedNfts, hasReachedMax: false));
          }
        } catch (e) {
          emit(NftError(message: e.toString()));
        }
        isFetching = false;
      }
    });
  }
}
