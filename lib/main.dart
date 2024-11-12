import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_helipagos_mobile/blocs/coin_bloc.dart';
import 'package:prueba_helipagos_mobile/blocs/nft_bloc.dart';
import 'package:prueba_helipagos_mobile/events/nft_event.dart';
import 'package:prueba_helipagos_mobile/models/coin.dart';
import 'package:prueba_helipagos_mobile/screens/splash_screen.dart';
import 'package:prueba_helipagos_mobile/screens/coin_list_screen.dart';
import 'package:prueba_helipagos_mobile/screens/search_screen.dart';
import 'package:prueba_helipagos_mobile/screens/nft_list_screen.dart';
import 'package:prueba_helipagos_mobile/screens/coin_detail_screen.dart';
import 'package:prueba_helipagos_mobile/screens/welcome_screen.dart';
import 'package:prueba_helipagos_mobile/services/api_service.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
void main() {
  final apiService = ApiService();
  runApp(
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
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  int _currentIndex = 0;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _hasInternet = true;
  bool _isDarkTheme = false;

  final List<Widget> _screens = [
    const CoinListScreen(),
    const NftListScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connectivitySubscription = Connectivity()
          .onConnectivityChanged
          .listen((List<ConnectivityResult> results) {
        setState(() {
          _hasInternet =
              results.isNotEmpty && results.first != ConnectivityResult.none;
          if (!_hasInternet) {
            scaffoldMessengerKey.currentState?.showSnackBar(
              const SnackBar(content: Text("Se requiere conexión a internet")),
            );
          } else {
            scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'CoinGecko App',
      initialRoute: '/splash',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        if (settings.name == '/coin_detail') {
          final coin = settings.arguments as Coin;
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return CoinDetailScreen(coin: coin);
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final offsetAnimation = Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(animation);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          );
        }
        return null;
      },
      routes: {
        '/splash': (context) => const SplashScreen(),
        "/welcome": (context) => const WelcomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/home': (context) => Scaffold(
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
      },
    );
  }
}
