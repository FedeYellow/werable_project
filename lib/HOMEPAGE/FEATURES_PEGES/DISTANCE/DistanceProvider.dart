import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DistanceData.dart';
import 'package:werable_project/IMPACT/Login_server.dart';

class DistanceProvider extends ChangeNotifier {
  List<Distancedata> distances = [];

  void fetchData(String day) async {
    distances.clear();

    final data = await Impact.fetchDistanceData(day);

    if (data != null) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        distances.add(Distancedata.fromJson(data['data']['date'], data['data']['data'][i]));
      }

      // Calcola il totale dei passi
      final totalSteps = distances.fold<int>(0, (sum, item) => sum + item.value);

      // Salva nelle SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('totalSteps', totalSteps);

      notifyListeners();
    }
  }

  void clearData() {
    distances.clear();
    notifyListeners();
  }
}
