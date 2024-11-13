import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:prueba_helipagos_mobile/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_helipagos_mobile/blocs/coin_bloc.dart';
import 'package:prueba_helipagos_mobile/blocs/nft_bloc.dart';
import 'package:prueba_helipagos_mobile/screens/coin_list_screen.dart';
import 'package:prueba_helipagos_mobile/screens/nft_list_screen.dart';
import 'package:prueba_helipagos_mobile/screens/welcome_screen.dart';
import 'package:prueba_helipagos_mobile/services/api_service.dart';

/// Note: Ensure the device is in dark mode before running the test.
/// Alternatively, you can modify the brightness settings to test light mode first,
/// followed by dark mode in the final steps of the test.

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests\n', () {
    testWidgets('Full flow test\n', (WidgetTester tester) async {
      // Create ApiService mock instance
      final apiService = ApiService();
      // Start the app with provided blocs
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<CoinBloc>(
              create: (context) => CoinBloc(apiService),
            ),
            BlocProvider<NftBloc>(
              create: (context) => NftBloc(apiService: apiService),
            ),
          ],
          child: const MainApp(),
        ),
      );

      // Wait for SplashScreen to finish
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Verify WelcomeScreen is shown
      expect(find.byType(WelcomeScreen), findsOneWidget);

      // Swipe through WelcomeScreen pages
      for (int i = 0; i < 2; i++) {
        await tester.fling(
          find.byType(PageView),
          const Offset(-300, 0),
          1000,
        );
        await tester.pumpAndSettle();
      }

      // Verify last page is shown
      expect(find.text('Inversiones Inteligentes'), findsOneWidget);

      // Tap 'Comenzar' button to navigate to '/home'
      final comenzarButtonFinder = find.text('Comenzar');
      expect(comenzarButtonFinder, findsOneWidget);
      await tester.tap(comenzarButtonFinder);
      await tester.pump(const Duration(seconds: 3));

      // Verify Coins tab is shown
      expect(find.byType(CoinListScreen), findsOneWidget);
      expect(find.text('Mercado Crypto'), findsOneWidget);

      // Verify a list of coins is present
      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);

      // Verify at least one CoinCard is present
      final coinCardFinder = find.byType(CoinCard);
      expect(coinCardFinder, findsWidgets);

      // Verify 'Bitcoin' is present
      expect(find.text('Bitcoin'), findsOneWidget);

      // Find and tap 'Bitcoin' CoinCard
      final bitcoinCardFinder = find.widgetWithText(CoinCard, 'Bitcoin');
      expect(bitcoinCardFinder, findsOneWidget);
      await tester.ensureVisible(bitcoinCardFinder);
      await tester.tap(bitcoinCardFinder);
      await tester.pumpAndSettle();

      // Verify coin details page is shown
      expect(find.text('Detalles'), findsOneWidget);

      // Go back to coin list
      await tester.pageBack();
      await tester.pump(const Duration(seconds: 2));

      // Switch to NFTs tab
      final nftsTabFinder = find.byIcon(Icons.art_track);
      expect(nftsTabFinder, findsOneWidget);
      await tester.tap(nftsTabFinder);
      await tester.pump(const Duration(seconds: 2));

      // Verify NFTs list is shown
      final nftsListFinder = find.byType(ListView);
      expect(nftsListFinder, findsOneWidget);
      await tester.pump(const Duration(seconds: 3));

      // Tap the first NFT in the list
      final nftCardFinder = find.byType(NftCard);
      expect(nftCardFinder, findsWidgets);
      await tester.tap(nftCardFinder.first);
      await tester.pump(const Duration(seconds: 2));

      // Verify NFT details page is shown
      expect(find.text('Detalle del NFT'), findsOneWidget);

      // Go back to NFTs list
      await tester.pageBack();
      await tester.pump(const Duration(seconds: 2));

      // Switch back to Coins tab
      final coinTabFinder = find.byIcon(Icons.monetization_on);
      expect(coinTabFinder, findsOneWidget);
      await tester.tap(coinTabFinder);
      await tester.pump(const Duration(seconds: 2));

      // Test theme change
      final themeButtonFinder = find.byIcon(Icons.brightness_6);
      expect(themeButtonFinder, findsOneWidget);

      await tester.tap(themeButtonFinder);
      await tester.pump(const Duration(seconds: 2));

      // Change theme back
      await tester.tap(themeButtonFinder);
      await tester.pump(const Duration(seconds: 2));
    });
  });
}
