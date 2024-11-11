import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';
import '../events/coin_event.dart';
import '../states/coin_state.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  final ApiService apiService;
  int currentPage = 1;
  bool isFetching = false;

  CoinBloc(this.apiService) : super(CoinInitial()) {
    on<FetchCoins>(_onFetchCoins);
    on<SearchCoins>(_onSearchCoins);
  }

  Future<void> _onFetchCoins(FetchCoins event, Emitter<CoinState> emit) async {
    if (isFetching) return;
    isFetching = true;

    try {
      if (state is CoinInitial || event.refresh) {
        currentPage = 1;
        emit(CoinLoading());
        final coins = await apiService.fetchCoins(page: currentPage);
        emit(CoinLoaded(coins: coins, hasReachedMax: false));
      } else if (state is CoinLoaded) {
        currentPage++;
        final coins = await apiService.fetchCoins(page: currentPage);
        if (coins.isEmpty) {
          emit((state as CoinLoaded).copyWith(hasReachedMax: true));
        } else {
          emit(CoinLoaded(
            coins: (state as CoinLoaded).coins + coins,
            hasReachedMax: false,
          ));
        }
      }
    } catch (e) {
      emit(CoinError(message: e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _onSearchCoins(
      SearchCoins event, Emitter<CoinState> emit) async {
    emit(CoinLoading());
    try {
      final coins = await apiService.searchCoins(event.query);
      emit(CoinLoaded(coins: coins, hasReachedMax: true));
    } catch (e) {
      emit(CoinError(message: e.toString()));
    }
  }
}
