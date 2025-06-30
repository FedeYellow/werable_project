
import 'package:flutter/material.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesData.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/WEEK/CaloriesWeekData.dart';
import 'package:werable_project/IMPACT/Login_server.dart';


class Caloriesprovider extends ChangeNotifier {

 
  //This serves as database of the application
  List<Caloriesdata> calories = [];
  List<CaloriesWeekData> weeklyCalories = [];


  //Method to fetch step data from the server
  void fetchData(String day) async {

    //Get the response
    final data = await Impact.fetchCaloriesData(day);

    //if OK parse the response adding all the elements to the list, otherwise do nothing
    if (data != null) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        calories.add(
            Caloriesdata.fromJson(data['data']['date'], data['data']['data'][i]));
      } //for

      //remember to notify the listeners
      notifyListeners();
    }//if

  }//fetchStepData


  void fetchWeekData(String startDate, String endDate) async {
  final data = await Impact.fetchCaloriesWeekData(startDate, endDate);
  if (data != null) {
    weeklyCalories.clear();

    for (var day in data['data']) {
      String date = day['date'];
      for (var item in day['data']) {
        weeklyCalories.add(CaloriesWeekData.fromJsonWithDate(date, item));
      }
    }

    notifyListeners();
  }
}


  //Method to clear the "memory"
  void clearData() {
    calories.clear();
    weeklyCalories.clear();
    notifyListeners();
  }//clearData





 



}

  
  
