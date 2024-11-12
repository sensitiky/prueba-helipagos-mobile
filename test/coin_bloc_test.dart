import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:prueba_helipagos_mobile/blocs/coin_bloc.dart';
import 'package:prueba_helipagos_mobile/events/coin_event.dart';
import 'package:prueba_helipagos_mobile/services/api_service.dart';
import 'package:prueba_helipagos_mobile/models/coin.dart';
import 'package:mockito/mockito.dart';
import 'package:prueba_helipagos_mobile/states/coin_state.dart';

@GenerateMocks([ApiService])
void main() {
  group('CoinBloc', () {
    late CoinBloc coinBloc;
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
      coinBloc = CoinBloc(mockApiService);
    });

    tearDown(() {
      coinBloc.close();
    });

    blocTest<CoinBloc, CoinState>(
      'emite [CoinLoading, CoinLoaded] cuando FetchCoins es añadido',
      build: () {
        when(mockApiService.fetchCoins()).thenAnswer(
          (_) async => [
            Coin(
              id: 'bitcoin',
              name: 'Bitcoin',
              symbol: 'BTC',
              currentPrice: 50000,
            ),
          ],
        );
        return coinBloc;
      },
      act: (bloc) => bloc.add(const FetchCoins()),
      expect: () => [
        CoinLoading(),
        isA<CoinLoaded>(),
      ],
    );

    blocTest<CoinBloc, CoinState>(
      'emite [CoinLoading, CoinError] cuando fetchCoins falla',
      build: () {
        when(mockApiService.fetchCoins())
            .thenThrow(Exception('Error de fetch'));
        return coinBloc;
      },
      act: (bloc) => bloc.add(const FetchCoins()),
      expect: () => [
        CoinLoading(),
        isA<CoinError>(),
      ],
    );
  });
}
