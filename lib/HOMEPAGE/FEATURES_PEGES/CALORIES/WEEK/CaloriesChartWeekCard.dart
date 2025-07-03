import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesProvider.dart';

class WeeklyCaloriesChartCard extends StatefulWidget {
  const WeeklyCaloriesChartCard({super.key});

  @override
  State<WeeklyCaloriesChartCard> createState() => _WeeklyCaloriesChartCardState();
}

class _WeeklyCaloriesChartCardState extends State<WeeklyCaloriesChartCard> {
  int? bmr;
  final dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _loadBmr();
    _fetchWeekDataAndSave();
  }

  Future<void> _loadBmr() async {
    final prefs = await SharedPreferences.getInstance();
    final storedBmr = prefs.getInt('bmr');
    if (storedBmr != null && mounted) {
      setState(() {
        bmr = storedBmr;
      });
    }
  }

  Future<void> _fetchWeekDataAndSave() async {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final monday = yesterday.subtract(Duration(days: yesterday.weekday - 1));
    final startStr = dateFormat.format(monday);
    final endStr = dateFormat.format(yesterday);

    final fullWeek = List.generate(8, (i) => monday.add(Duration(days: i)));

    // Carica i dati salvati da SharedPreferences nel provider
    await context.read<Caloriesprovider>().loadDailyCaloriesFromPrefs(fullWeek);

    // Chiamata fetchWeekData senza await perché è void
    context.read<Caloriesprovider>().fetchWeekData(startStr, endStr);

    // Piccola attesa per sicurezza che i dati si aggiornino
    await Future.delayed(const Duration(milliseconds: 100));

    final weekData = context.read<Caloriesprovider>().weeklyCalories;

    final Map<String, int> dailyTotals = {};
    for (final entry in weekData) {
      final key = dateFormat.format(entry.date);
      dailyTotals[key] = (dailyTotals[key] ?? 0) + entry.value;
    }

    final prefs = await SharedPreferences.getInstance();
    for (final date in fullWeek) {
      final key = dateFormat.format(date);
      final value = dailyTotals[key] ?? 0;
      await prefs.setInt('daily_total_calories_$key', value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final weekData = context.watch<Caloriesprovider>().weeklyCalories;
    final now = DateTime.now();

    final monday = now.subtract(Duration(days: now.weekday - 1));
    final fullWeek = List.generate(8, (i) => monday.add(Duration(days: i)));

    final labelFormat = DateFormat.E('en_US');

    final dailyTotals = <String, int>{};
    for (final entry in weekData) {
      final key = dateFormat.format(entry.date);
      dailyTotals[key] = (dailyTotals[key] ?? 0) + entry.value;
    }

    final chartData = fullWeek.map((date) {
      final key = dateFormat.format(date);
      final label = '${labelFormat.format(date)}\n${date.day}';

      int value;
      Color color;

      if (_isSameDay(date, now)) {
        final hasData = dailyTotals.containsKey(key);
        value = hasData ? dailyTotals[key]! : (bmr ?? 0);
        color = hasData ? Colors.blue : Colors.grey;
      } else if (date.isBefore(now)) {
        value = dailyTotals[key] ?? 0;
        color = Colors.blue;
      } else {
        value = 0;
        color = Colors.blue.shade100;
      }

      return _DayCalories(day: label, calories: value, color: color);
    }).toList();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                _LegendItem(color: Colors.blue, label: 'Calories'),
                SizedBox(width: 16),
                _LegendItem(color: Colors.grey, label: 'BMR'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SfCartesianChart(
              title: const ChartTitle(text: 'Weekly Calories'),
              primaryXAxis: CategoryAxis(),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(text: 'Calories (kcal)'),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              legend: const Legend(isVisible: false),
              series: <CartesianSeries<_DayCalories, String>>[
                ColumnSeries<_DayCalories, String>(
                  dataSource: chartData,
                  xValueMapper: (data, _) => data.day,
                  yValueMapper: (data, _) => data.calories,
                  pointColorMapper: (data, _) => data.color,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DayCalories {
  final String day;
  final int calories;
  final Color color;

  _DayCalories({required this.day, required this.calories, required this.color});
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}