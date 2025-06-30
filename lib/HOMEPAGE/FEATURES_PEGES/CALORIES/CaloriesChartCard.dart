import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesData.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesProvider.dart';

class CaloriesChartCard extends StatelessWidget {
  const CaloriesChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final calories = context.watch<Caloriesprovider>().calories;

    // Calorie totali
    final totalCalories =
        calories.fold<int>(0, (sum, item) => sum + item.value);

    // Metabolismo basale stimato
    final basalMetabolism = 1800;

    // Media calorie ogni 2 ore
    final grouped = _groupCaloriesByTwoHours(calories);

    return Card(
      margin: const EdgeInsets.all(12),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/detailedCaloriesChart');
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const Text(
                'Calorie Bruciate (media ogni 2 ore)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                  intervalType: DateTimeIntervalType.hours,
                  interval: 2,
                  dateFormat: DateFormat.Hm(),
                  title: AxisTitle(text: 'Ora'),
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Kcal'),
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries<_CalorieBlock, DateTime>>[
                  LineSeries<_CalorieBlock, DateTime>(
                    dataSource: grouped,
                    xValueMapper: (data, _) => data.time,
                    yValueMapper: (data, _) => data.average,
                    markerSettings: const MarkerSettings(isVisible: true),
                    dataLabelSettings:
                        const DataLabelSettings(isVisible: false),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Totale: $totalCalories Kcal'),
              Text('Metabolismo Basale: $basalMetabolism Kcal'),
            ],
          ),
        ),
      ),
    );
  }

  List<_CalorieBlock> _groupCaloriesByTwoHours(List<Caloriesdata> data) {
    final Map<DateTime, List<int>> buckets = {};

    for (var entry in data) {
      // Raggruppa per ogni blocco da 2 ore (00:00–01:59, 02:00–03:59, ecc.)
      final roundedHour = DateTime(
        entry.time.year,
        entry.time.month,
        entry.time.day,
        (entry.time.hour ~/ 2) * 2,
      );
      buckets.putIfAbsent(roundedHour, () => []).add(entry.value);
    }

    return buckets.entries.map((entry) {
      final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
      return _CalorieBlock(time: entry.key, average: avg);
    }).toList()
      ..sort((a, b) => a.time.compareTo(b.time)); // Ordina cronologicamente
  }
}

class _CalorieBlock {
  final DateTime time;
  final double average;

  _CalorieBlock({required this.time, required this.average});
}
