import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesProvider.dart';

class WeeklyCaloriesDeltaChartCard extends StatefulWidget {
  const WeeklyCaloriesDeltaChartCard({super.key});

  @override
  State<WeeklyCaloriesDeltaChartCard> createState() => _WeeklyCaloriesDeltaChartCardState();
}

class _WeeklyCaloriesDeltaChartCardState extends State<WeeklyCaloriesDeltaChartCard> {
  final int fixedCaloriesIn = 1000;
  final dateFormat = DateFormat('yyyy-MM-dd');

  List<_DayDelta> chartData = [];
  int totalDelta = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _prepareChartData();
  }

  void _prepareChartData() {
    final provider = context.watch<Caloriesprovider>();

    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final monday = yesterday.subtract(Duration(days: yesterday.weekday - 1));
    final fullWeek = List.generate(8, (i) => monday.add(Duration(days: i)));

    List<_DayDelta> tempData = [];
    int tempTotalDelta = 0;

    for (final date in fullWeek) {
      final key = dateFormat.format(date);
      final caloriesOut = provider.getDailyCalories(key);

      final delta = (caloriesOut > 0) ? fixedCaloriesIn - caloriesOut : 0;

      tempTotalDelta += delta;

      final label = '${DateFormat.E('en_US').format(date)}\n${date.day}';
      tempData.add(_DayDelta(day: label, delta: delta));
    }

    setState(() {
      chartData = tempData;
      totalDelta = tempTotalDelta;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (chartData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    String nutritionStatus;
    if (totalDelta > 0) {
      nutritionStatus = 'Overnutrition';
    } else if (totalDelta < 0) {
      nutritionStatus = 'Undernutrition';
    } else {
      nutritionStatus = 'Balanced nutrition';
    }

    final totalDeltaString = (totalDelta >= 0 ? '+' : '') + totalDelta.toString();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SfCartesianChart(
              title: ChartTitle(text: 'Weekly Calorie Delta'),
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Calorie Delta (kcal)'),
                minimum: -3000,
                maximum: 3000,
                interval: 1000,
                plotBands: <PlotBand>[
                  PlotBand(
                    isVisible: true,
                    start: 0,
                    end: 0,
                    borderColor: Colors.green,
                    borderWidth: 1,
                  ),
                ],
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              legend: Legend(isVisible: false),
              series: <CartesianSeries<_DayDelta, String>>[
                LineSeries<_DayDelta, String>(
                  dataSource: chartData,
                  xValueMapper: (data, _) => data.day,
                  yValueMapper: (data, _) => data.delta,
                  color: Colors.blue,
                  pointColorMapper: (data, _) =>
                      data.delta >= 0 ? Colors.green : Colors.red,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.top,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Total Calorie Delta: $totalDeltaString kcal ($nutritionStatus)',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayDelta {
  final String day;
  final int delta;

  _DayDelta({required this.day, required this.delta});
}
