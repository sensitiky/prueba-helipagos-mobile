import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:prueba_helipagos_mobile/models/coin.dart';

class CoinCard extends StatelessWidget {
  final Coin coin;

  const CoinCard({required this.coin, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (coin.imageUrl != null)
                Image.network(
                  coin.imageUrl!,
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.monetization_on, size: 50),
                )
              else
                const Icon(Icons.monetization_on, size: 50),
              const SizedBox(height: 8),
              Text(
                coin.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                coin.symbol.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade300,
                ),
              ),
              const SizedBox(height: 8),
              // Precio actual
              coin.currentPrice != null
                  ? Text(
                      '\$${coin.currentPrice!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'N/A',
                      style: TextStyle(color: Colors.white),
                    ),
              if (coin.priceChange != null)
                Text(
                  '${coin.priceChange! >= 0 ? '+' : ''}${coin.priceChange!.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: coin.priceChange! >= 0
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
