import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'CaloriesProvider.dart';
import 'CaloriesData.dart';

class CaloriesDetailPage extends StatelessWidget {
  const CaloriesDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final calories = context.watch<Caloriesprovider>().calories;

    return Scaffold(
      appBar: AppBar(title: const Text('Dettaglio Calorie')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SfCartesianChart(
          title: ChartTitle(text: 'Grafico Completo delle Calorie'),
          primaryXAxis: DateTimeAxis(
            intervalType: DateTimeIntervalType.hours,
            dateFormat: DateFormat.Hm(),
            title: AxisTitle(text: 'Ora'),
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Kcal'),
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<Caloriesdata, DateTime>>[
            LineSeries<Caloriesdata, DateTime>(
              dataSource: calories,
              xValueMapper: (data, _) => data.time,
              yValueMapper: (data, _) => data.value,
              markerSettings: const MarkerSettings(isVisible: true),
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }
}
