import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_helipagos_mobile/main.dart' as app;
import 'package:prueba_helipagos_mobile/blocs/coin_bloc.dart';
import 'package:prueba_helipagos_mobile/blocs/nft_bloc.dart';
import 'package:prueba_helipagos_mobile/services/api_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService();
    });

    Widget createTestApp() {
      return MultiBlocProvider(
        providers: [
          BlocProvider<CoinBloc>(
            create: (context) => CoinBloc(apiService),
          ),
          BlocProvider<NftBloc>(
            create: (context) => NftBloc(apiService: apiService),
          ),
        ],
        child: const app.MainApp(),
      );
    }

    testWidgets('Pull to refresh test', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Wait for initial data load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find the ListView using more specific finder
      final listViewFinder = find.byType(ListView).last;
      expect(listViewFinder, findsOneWidget);

      // Perform pull to refresh
      await tester.drag(listViewFinder, const Offset(0, 300));
      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('Infinite scroll test', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Wait for initial data load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find ListView more specifically
      final listViewFinder = find.byType(ListView).last;
      expect(listViewFinder, findsOneWidget);

      final initialItemCount = find.byType(ListTile).evaluate().length;

      // Scroll to trigger pagination
      await tester.fling(listViewFinder, const Offset(0, -500), 1000);
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      final newItemCount = find.byType(ListTile).evaluate().length;
      expect(newItemCount, greaterThan(initialItemCount));
    });
  });
}
