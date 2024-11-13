import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:prueba_helipagos_mobile/services/api_service.dart';

class CoinPriceChart extends StatefulWidget {
  final String coinId;

  const CoinPriceChart({super.key, required this.coinId});

  @override
  CoinPriceChartState createState() => CoinPriceChartState();
}

class CoinPriceChartState extends State<CoinPriceChart> {
  late Future<List<FlSpot>> _priceSpotsFuture;

  @override
  void initState() {
    super.initState();
    _priceSpotsFuture = ApiService().fetchHistoricalPrices(widget.coinId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FlSpot>>(
      future: _priceSpotsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text(
            'Error al cargar el gráfico: ${snapshot.error}',
            style: const TextStyle(color: Colors.red),
          );
        } else if (snapshot.hasData) {
          List<FlSpot> spots = snapshot.data!;
          double minY =
              spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
          double maxY =
              spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: spots.length / 5,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < spots.length) {
                          DateTime date = DateTime.now()
                              .subtract(Duration(days: spots.length - index));
                          return Text('${date.day}/${date.month}');
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: spots.length.toDouble() - 1,
                minY: minY * 1,
                maxY: maxY * 1,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.blueAccent,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Text('No hay datos disponibles para el gráfico');
        }
      },
    );
  }
}
