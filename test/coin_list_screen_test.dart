import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_helipagos_mobile/blocs/coin_bloc.dart';
import 'package:prueba_helipagos_mobile/models/coin.dart';
import 'package:prueba_helipagos_mobile/screens/coin_list_screen.dart';
import 'package:prueba_helipagos_mobile/states/coin_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([CoinBloc])
void main() {
  group('CoinListScreen', () {
    late MockCoinBloc mockCoinBloc;

    setUp(() {
      mockCoinBloc = MockCoinBloc();
    });

    tearDown(() {
      mockCoinBloc.close();
    });

    testWidgets('Muestra lista de coins cuando CoinLoaded',
        (WidgetTester tester) async {
      when(mockCoinBloc.state).thenReturn(CoinLoading());
      whenListen(
        mockCoinBloc,
        Stream<CoinState>.fromIterable([
          CoinLoading(),
          CoinLoaded(
            hasReachedMax: false,
            coins: [
              Coin(
                id: 'bitcoin',
                name: 'Bitcoin',
                symbol: 'BTC',
                currentPrice: 50000,
              ),
            ],
          ),
        ]),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CoinBloc>.value(
            value: mockCoinBloc,
            child: const CoinListScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.text('Símbolo: BTC'), findsOneWidget);
      expect(find.text('\$50000.00'), findsOneWidget);
    });

    testWidgets('Muestra mensaje de error cuando CoinError',
        (WidgetTester tester) async {
      when(mockCoinBloc.state).thenReturn(CoinLoading());
      whenListen(
        mockCoinBloc,
        Stream<CoinState>.fromIterable([
          CoinLoading(),
          const CoinError(message: 'Error al cargar coins'),
        ]),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CoinBloc>.value(
            value: mockCoinBloc,
            child: const CoinListScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      expect(find.text('Error al cargar coins'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });
  });
}
