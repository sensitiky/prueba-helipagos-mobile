import 'package:flutter/material.dart';
import 'package:prueba_helipagos_mobile/models/coin.dart';

class CoinDetailScreen extends StatefulWidget {
  final Coin coin;

  const CoinDetailScreen({super.key, required this.coin});

  @override
  CoinDetailScreenState createState() => CoinDetailScreenState();
}

class CoinDetailScreenState extends State<CoinDetailScreen> {
  final TextEditingController capitalController = TextEditingController();

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
                        hintText: 'Capital',
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      color: Colors.amber,
                      size: 32,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "Ingresa tu capital en USD para convertirlo al token seleccionado.",
                        style: TextStyle(
                          fontSize: 16,
                        ),
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
