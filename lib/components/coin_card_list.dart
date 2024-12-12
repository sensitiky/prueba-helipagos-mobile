import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:prueba_helipagos_mobile/models/coin.dart';

class CoinCard extends StatelessWidget {
  final Coin coin;

  const CoinCard({required this.coin, super.key});

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.2)
        : Colors.black.withOpacity(0.2);

    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.15)
        : Colors.black12;

    final changePriceColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.greenAccent
        : const Color(0xFF2D7130);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
            ),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
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
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Column(
                        children: [
                          Text(
                            coin.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            coin.symbol.toUpperCase(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        coin.currentPrice != null
                            ? Text(
                                '\$${coin.currentPrice!.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
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
                                  ? changePriceColor
                                  : Colors.redAccent,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
