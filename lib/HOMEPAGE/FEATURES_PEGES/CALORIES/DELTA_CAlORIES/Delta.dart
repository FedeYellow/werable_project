import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesProvider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/DELTA_CAlORIES/InfoPage.dart';

class WeeklyCaloriesDeltaChartCard extends StatefulWidget {
  const WeeklyCaloriesDeltaChartCard({super.key});

  @override
  State<WeeklyCaloriesDeltaChartCard> createState() =>
      _WeeklyCaloriesDeltaChartCardState();
}

class _WeeklyCaloriesDeltaChartCardState
    extends State<WeeklyCaloriesDeltaChartCard> {
  final dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Caloriesprovider>();

    if (!provider.isWeekDataLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final chartData = _generateChartData(provider);
    final totalDelta = chartData.fold<int>(0, (sum, item) => sum + item.delta);

    String nutritionStatus;
    if (totalDelta > 0) {
      nutritionStatus = 'Overnutrition';
    } else if (totalDelta < 0) {
      nutritionStatus = 'Undernutrition';
    } else {
      nutritionStatus = 'Balanced nutrition';
    }

    final totalDeltaString =
        (totalDelta >= 0 ? '+' : '') + totalDelta.toString();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Weekly Calorie Delta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: 'Learn more about nutritional status',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NutritionInfoPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Calorie Delta (kcal)'),
                minimum: -5000,
                maximum: 5000,
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
              legend: const Legend(isVisible: false),
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

  List<_DayDelta> _generateChartData(Caloriesprovider provider) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final monday = yesterday.subtract(Duration(days: yesterday.weekday - 1));
    final fullWeek = List.generate(8, (i) => monday.add(Duration(days: i)));

    return fullWeek.map((date) {
      final key = dateFormat.format(date);
      final caloriesOut = provider.getDailyCalories(key);
      final caloriesIn = provider.diaryCaloriesMap[key] ?? 0;
      final delta = caloriesIn - caloriesOut;

      final label = '${DateFormat.E('en_US').format(date)}\n${date.day}';
      return _DayDelta(day: label, delta: delta);
    }).toList();
  }
}

class _DayDelta {
  final String day;
  final int delta;

  _DayDelta({required this.day, required this.delta});
}
