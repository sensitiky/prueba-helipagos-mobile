import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:prueba_helipagos_mobile/models/coin.dart';
import 'package:prueba_helipagos_mobile/services/api_service.dart';
import 'package:prueba_helipagos_mobile/widgets/coin_price_chart.dart';

class CoinDetailScreen extends StatefulWidget {
  final Coin coin;

  const CoinDetailScreen({super.key, required this.coin});

  @override
  CoinDetailScreenState createState() => CoinDetailScreenState();
}

class CoinDetailScreenState extends State<CoinDetailScreen> {
  final TextEditingController capitalController = TextEditingController();
  late Future<List<FlSpot>> _priceSpots;

  @override
  void initState() {
    super.initState();
    _priceSpots = ApiService().fetchHistoricalPrices(widget.coin.id);
  }

  @override
  void dispose() {
    capitalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Coin coin = widget.coin;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage:
                  coin.imageUrl != null ? NetworkImage(coin.imageUrl!) : null,
              child: coin.imageUrl == null
                  ? const Icon(Icons.monetization_on,
                      size: 50, color: Colors.grey)
                  : null,
            ),
            const SizedBox(height: 24),
            Text(
              coin.symbol.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              coin.name,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            coin.currentPrice != null
                ? Text(
                    '1 ${coin.symbol.toUpperCase()} = \$${coin.currentPrice!.toStringAsFixed(3)} USD\n 1 USD = ${(1 / coin.currentPrice!)} ${coin.symbol.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : const Text(
                    'Precio no disponible',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: capitalController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.attach_money),
                        hintText: 'Ingrese su capital en USD',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        "Convertir",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      capitalController.text.isNotEmpty &&
                              coin.currentPrice != null
                          ? 'Valor: ${(double.parse(capitalController.text) / coin.currentPrice!)} ${coin.symbol.toUpperCase()}'
                          : '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 320,
                      child: FutureBuilder<List<FlSpot>>(
                        future: _priceSpots,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            return CoinPriceChart(
                              coinId: coin.id,
                            );
                          } else {
                            return const Text("Error al cargar la información");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
