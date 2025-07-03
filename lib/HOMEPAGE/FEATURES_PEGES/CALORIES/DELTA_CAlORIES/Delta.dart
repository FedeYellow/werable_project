import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void reassemble() {
    super.reassemble();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final bmr = prefs.getInt('bmr') ?? 0;

    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final monday = yesterday.subtract(Duration(days: yesterday.weekday - 1));
    final fullWeek = List.generate(8, (i) => monday.add(Duration(days: i)));

    List<_DayDelta> tempData = [];
    int tempTotalDelta = 0;

    for (final date in fullWeek) {
      final key = dateFormat.format(date);
      final caloriesOut = prefs.getInt('daily_total_calories_$key') ?? 0;

      final delta = (caloriesOut > 0 && caloriesOut != bmr)
          ? fixedCaloriesIn - caloriesOut
          : 0;

      tempTotalDelta += delta;

      final label = '${DateFormat.E('en_US').format(date)}\n${date.day}';

      tempData.add(_DayDelta(day: label, delta: delta));
    }

    if (mounted) {
      setState(() {
        chartData = tempData;
        totalDelta = tempTotalDelta;
      });
    }
  }

  void _openNutritionInfo() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const NutritionInfoPage()),
    );
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _openNutritionInfo,
              child: const Text('Learn about Nutrition Risks'),
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

class NutritionInfoPage extends StatelessWidget {
  const NutritionInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Risks Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Overnutrition Risks',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Overnutrition occurs when calorie intake consistently exceeds the body’s energy requirements. This can lead to:'
                '\n\n• Overweight and obesity'
                '\n• Cardiovascular diseases (heart disease, stroke)'
                '\n• Type 2 diabetes'
                '\n• Certain types of cancer (e.g., breast, colon)'
                '\n• Fatty liver disease'
                '\n• Joint problems and decreased mobility'
                '\n\nManaging caloric intake and increasing physical activity are essential to prevent these risks.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                'Undernutrition Risks',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Undernutrition results from inadequate calorie consumption to meet the body’s energy demands. Potential health consequences include:'
                '\n\n• Fatigue and weakness'
                '\n• Weakened immune system leading to infections'
                '\n• Muscle wasting and loss of strength'
                '\n• Delayed wound healing'
                '\n• Nutrient deficiencies and anemia'
                '\n• Growth and developmental delays in children'
                '\n\nTimely nutritional support and balanced diet are crucial to address undernutrition.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                'Balanced Nutrition',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Maintaining a balanced nutrition ensures adequate calorie intake matching energy expenditure. This supports:'
                '\n\n• Healthy body weight'
                '\n• Proper immune function'
                '\n• Muscle maintenance and strength'
                '\n• Overall physical and mental well-being',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
