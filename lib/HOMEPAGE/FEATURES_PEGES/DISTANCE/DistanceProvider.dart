
import 'package:flutter/material.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/DISTANCE/DistanceData.dart';
import 'package:werable_project/IMPACT/Login_server.dart';


class DistanceProvider extends ChangeNotifier {

 
  //This serves as database of the application
  List<Distancedata> distance = [];

  //Method to fetch step data from the server
  void fetchData(String day) async {

    //Get the response
    final data = await Impact.fetchDistanceData(day);

    //if OK parse the response adding all the elements to the list, otherwise do nothing
    if (data != null) {
      for (var i = 0; i < data['data']['data'].length; i++) {
        distance.add(
            Distancedata.fromJson(data['data']['date'], data['data']['data'][i]));
      } //for

      //remember to notify the listeners
      notifyListeners();
    }//if

  }//fetchStepData

  //Method to clear the "memory"
  void clearData() {
    distance.clear();
    notifyListeners();
  }//clearData


 



}

  
  
