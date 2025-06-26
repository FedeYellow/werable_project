import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesData.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesProvider.dart';
import 'package:intl/intl.dart';

class Caloriescard extends StatefulWidget {
  const Caloriescard({super.key});

  @override
  State<Caloriescard> createState() => _CaloriesCardState();
}

class _CaloriesCardState extends State<Caloriescard> {
  @override
  void initState() {
    super.initState();
    _fetchCaloriesData();
  }

  void _fetchCaloriesData() {
    final provider = Provider.of<Caloriesprovider>(context, listen: false);
    final ieri = DateTime.now().subtract(const Duration(days: 1));
    final dayString = DateFormat('yyyy-MM-dd').format(ieri);
    provider.fetchData(dayString);
  }

  @override
  Widget build(BuildContext context) {
    final caloriesList = context.watch<Caloriesprovider>().calories;

    int totalCal = _calcolaCalorieTotale(caloriesList);

    return Card(
      margin: const EdgeInsets.all(12),
      child: ListTile(
        title: const Text('Calorie Totale di Ieri'),
        subtitle: Text('${totalCal.toString()} Kcal'),
      ),
    );
  }

  int _calcolaCalorieTotale(List<Caloriesdata> lista) {
    int totaleKcal = lista.fold(0, (somma, item) => somma + item.value);
    return totaleKcal ;
  }
}
