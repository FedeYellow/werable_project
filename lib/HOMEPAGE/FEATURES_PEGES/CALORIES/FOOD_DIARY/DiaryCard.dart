import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesProvider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/FOOD_DIARY/DiaryPage.dart';

class DiaryCard extends StatefulWidget {
  const DiaryCard({super.key});

  @override
  State<DiaryCard> createState() => _DiaryCardState();
}

class _DiaryCardState extends State<DiaryCard> {
  final dateFormat = DateFormat('yyyy-MM-dd');
  final labelFormat = DateFormat.E('en_US');
  late final List<DateTime> fullWeek;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final monday = yesterday.subtract(Duration(days: yesterday.weekday - 1));
    fullWeek = List.generate(8, (i) => monday.add(Duration(days: i)));
    _loadDataFromPrefs();
  }

  Future<void> _loadDataFromPrefs() async {
    final provider = Provider.of<Caloriesprovider>(context, listen: false);
    provider.diaryCaloriesMap.clear(); // 🔁 Pulisce i dati vecchi
    await provider.loadDiaryCaloriesFromPrefs(fullWeek);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final diaryCaloriesMap =
        context.watch<Caloriesprovider>().diaryCaloriesMap;

    final chartData = fullWeek.map((date) {
      final label = '${labelFormat.format(date)}\n${date.day}';
      final key = dateFormat.format(date);
      final value = diaryCaloriesMap[key] ?? 0;
      return _DayCalories(day: label, calories: value);
    }).toList();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const Text('Food Diary',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SfCartesianChart(
                    title: const ChartTitle(text: 'Calorie introdotte'),
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: const NumericAxis(
                      title: AxisTitle(text: 'Calorie (kcal)'),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries<_DayCalories, String>>[
                      ColumnSeries<_DayCalories, String>(
                        dataSource: chartData,
                        xValueMapper: (data, _) => data.day,
                        yValueMapper: (data, _) => data.calories,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const FoodDiaryPage()),
                      );
                      await _loadDataFromPrefs(); // 🔁 Ricarica dati aggiornati
                    },
                    child: const Text('Mostra Diario'),
                  ),
                ],
              ),
      ),
    );
  }
}

class _DayCalories {
  final String day;
  final int calories;

  _DayCalories({required this.day, required this.calories});
}
