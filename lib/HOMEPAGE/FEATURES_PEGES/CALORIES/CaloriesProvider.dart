import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesData.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/WEEK/CaloriesWeekData.dart';
import 'package:werable_project/IMPACT/Login_server.dart';

class Caloriesprovider extends ChangeNotifier {
  List<Caloriesdata> calories = [];
  List<CaloriesWeekData> weeklyCalories = [];

  Map<String, int> dailyCaloriesMap = {};
  bool isWeekDataLoaded = false;

  void fetchData(String day) async {
    final data = await Impact.fetchCaloriesData(day);
    if (data != null) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        calories.add(
          Caloriesdata.fromJson(data['data']['date'], data['data']['data'][i]),
        );
      }
      notifyListeners();
    }
  }

  void fetchWeekData(String startDate, String endDate) async {
    final data = await Impact.fetchCaloriesWeekData(startDate, endDate);
    if (data != null) {
      weeklyCalories.clear();
      dailyCaloriesMap.clear();

      for (var day in data['data']) {
        String date = day['date'];
        for (var item in day['data']) {
          final entry = CaloriesWeekData.fromJsonWithDate(date, item);
          weeklyCalories.add(entry);

          final key = entry.date.toIso8601String().split('T').first;
          dailyCaloriesMap.update(
            key,
            (value) => value + entry.value,
            ifAbsent: () => entry.value,
          );
        }
      }

      isWeekDataLoaded = true;
      notifyListeners();
    }
  }

  Future<void> loadDailyCaloriesFromPrefs(List<DateTime> weekDates) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, int> loadedData = {};

    for (final date in weekDates) {
      final key = date.toIso8601String().split('T').first;
      loadedData[key] = prefs.getInt('daily_total_calories_$key') ?? 0;
    }
    dailyCaloriesMap = loadedData;
    notifyListeners();
  }

  int getDailyCalories(String dateKey) {
    return dailyCaloriesMap[dateKey] ?? 0;
  }

  void clearData() {
    calories.clear();
    weeklyCalories.clear();
    dailyCaloriesMap.clear();
    isWeekDataLoaded = false;
    notifyListeners();
  }
}
