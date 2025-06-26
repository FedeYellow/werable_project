import 'package:intl/intl.dart';


class Caloriesdata{
  final DateTime time;
  final int value;

  Caloriesdata({required this.time, required this.value});

  Caloriesdata.fromJson(String date, Map<String, dynamic> json) :
      time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
      value = double.parse(json["value"]).round();
      

  @override
  String toString() {
    return 'StepData(time: $time, value: $value)';
  }//toString

  
}

