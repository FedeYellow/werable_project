import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesProvider.dart';


class WeeklyCaloriesChartCard extends StatefulWidget {
  const WeeklyCaloriesChartCard({super.key});

  @override
  State<WeeklyCaloriesChartCard> createState() => _WeeklyCaloriesChartCardState();
}

class _WeeklyCaloriesChartCardState extends State<WeeklyCaloriesChartCard> {
  @override
  void initState() {
    super.initState();

    final today = DateTime.now();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));;
    final start = today.subtract(const Duration(days: 6));
    final startStr = DateFormat('yyyy-MM-dd').format(start);
    final endStr = DateFormat('yyyy-MM-dd').format(yesterday);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Caloriesprovider>().fetchWeekData(startStr, endStr);
    });
  }

  @override
  Widget build(BuildContext context) {
    final weeklyData = context.watch<Caloriesprovider>().weeklyCalories;

    // Somma calorie per giorno
    final Map<DateTime, int> dailyTotals = {};
    for (var entry in weeklyData) {
      final dateOnly = DateTime(entry.date.year, entry.date.month, entry.date.day);
      dailyTotals.update(dateOnly, (prev) => prev + entry.value, ifAbsent: () => entry.value);
    }

    // Trasforma in lista per il grafico
    final List<_DayCalories> chartData = dailyTotals.entries
        .map((e) => _DayCalories(day: e.key, total: e.value))
        .toList()
      ..sort((a, b) => a.day.compareTo(b.day));

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              'Calorie Totali per Giorno (Ultimi 7 giorni)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SfCartesianChart(
              primaryXAxis: CategoryAxis(
                title: AxisTitle(text: 'Giorno'),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Calorie'),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<_DayCalories, String>>[
                LineSeries<_DayCalories, String>(
                  dataSource: chartData,
                  xValueMapper: (data, _) => DateFormat.E().format(data.day),
                  yValueMapper: (data, _) => data.total,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCalories {
  final DateTime day;
  final int total;

  _DayCalories({required this.day, required this.total});
}
