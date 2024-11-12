import 'package:flutter/material.dart';
import '../models/coin.dart';

class CoinDetailScreen extends StatefulWidget {
  const CoinDetailScreen({super.key});

  @override
  CoinDetailScreenState createState() => CoinDetailScreenState();
}

class CoinDetailScreenState extends State<CoinDetailScreen> {
  late Coin coin;
  final TextEditingController capitalController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    coin = ModalRoute.of(context)!.settings.arguments as Coin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Detalles"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
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
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              coin.name,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[700],
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
                    coin.currentPrice != null
                        ? Text(
                            'Precio: \$${coin.currentPrice!.toStringAsFixed(2)} USD',
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
                    TextField(
                      controller: capitalController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.attach_money),
                        hintText: 'Ingrese el capital en USD',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
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
                          ? 'Valor: ${(double.tryParse(capitalController.text) ?? 0) / coin.currentPrice!} ${coin.symbol.toUpperCase()}'
                          : 'Ingrese un capital válido',
                      style: TextStyle(
                        fontSize: 18,
                        color: capitalController.text.isNotEmpty &&
                                coin.currentPrice != null
                            ? Colors.black87
                            : Colors.red[600],
                        fontWeight: FontWeight.w500,
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
