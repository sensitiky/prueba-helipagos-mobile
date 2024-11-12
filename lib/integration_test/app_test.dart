import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:prueba_helipagos_mobile/events/nft_event.dart';
import 'package:prueba_helipagos_mobile/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_helipagos_mobile/blocs/coin_bloc.dart';
import 'package:prueba_helipagos_mobile/blocs/nft_bloc.dart';
import 'package:prueba_helipagos_mobile/services/api_service.dart';
import 'package:prueba_helipagos_mobile/screens/coin_detail_screen.dart';
import 'package:prueba_helipagos_mobile/screens/nft_detail_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Pruebas de Integración de la Aplicación\n', () {
    testWidgets('Prueba de flujo completo\n', (WidgetTester tester) async {
      // Crear instancia de ApiService
      final apiService = ApiService();

      // Iniciar la aplicación con los blocs proporcionados
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<CoinBloc>(
              create: (context) => CoinBloc(apiService),
            ),
            BlocProvider<NftBloc>(
              create: (context) =>
                  NftBloc(apiService: apiService)..add(FetchNfts()),
            ),
          ],
          child: const MainApp(),
        ),
      );
      await tester.pumpAndSettle(const Duration(seconds: 4));
      // Verificar que se muestra la pestaña de Coins
      expect(find.text('Mercado Crypto'), findsOneWidget);

      // Desplazarse hacia abajo en la lista de monedas para activar la paginación
      final coinsListFinder = find.byKey(const Key('coinList'));
      expect(coinsListFinder, findsOneWidget);

      await tester.fling(coinsListFinder, const Offset(0, -500), 1000);
      await tester.pumpAndSettle();

      // Tocar la primera moneda de la lista
      final firstCoinFinder = find.byKey(const Key('coinItem_0'));
      await tester.tap(firstCoinFinder);
      await tester.pumpAndSettle();

      // Verificar que se muestra la página de detalles de la moneda
      expect(find.byType(CoinDetailScreen), findsOneWidget);

      // Volver a la lista de monedas
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Cambiar a la pestaña de NFTs
      final nftsTabFinder = find.byIcon(Icons.art_track);
      await tester.tap(nftsTabFinder);
      await tester.pumpAndSettle();

      // Verificar que se muestra la lista de NFTs
      final nftsListFinder = find.byKey(const Key('nftsList'));
      expect(nftsListFinder, findsOneWidget);

      // Desplazarse hacia abajo en la lista de NFTs para activar la paginación
      await tester.fling(nftsListFinder, const Offset(0, -500), 1000);
      await tester.pumpAndSettle();

      // Tocar el primer NFT de la lista
      final firstNftFinder = find.byKey(const Key('nftItem_0'));
      await tester.tap(firstNftFinder);
      await tester.pumpAndSettle();

      // Verificar que se muestra la página de detalles del NFT
      expect(find.byType(NftDetailScreen), findsOneWidget);
    });
  });
}
