import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'events/coin_event.dart';
import 'events/nft_event.dart';
import 'services/api_service.dart';
import 'blocs/coin_bloc.dart';
import 'blocs/nft_bloc.dart';
import 'screens/coin_list_screen.dart';
import 'screens/coin_detail_screen.dart';
import 'screens/search_screen.dart';
import 'screens/nft_list_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  final apiService = ApiService();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CoinBloc>(
          create: (context) => CoinBloc(apiService),
        ),
        BlocProvider<NftBloc>(
          create: (context) => NftBloc(apiService)..add(FetchNfts()),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CoinsListScreen(),
    const NftListScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        BlocProvider.of<CoinBloc>(context).add(const FetchCoins(refresh: true));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinGecko App',
      initialRoute: '/splash',
      debugShowCheckedModeBanner: false,
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/coin_detail': (context) => const CoinDetailScreen(),
        '/search': (context) => const SearchScreen(),
      },
      home: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              label: 'Coins',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.art_track),
              label: 'NFTs',
            ),
          ],
          selectedItemColor: Colors.blue,
        ),
      ),
    );
  }
}
