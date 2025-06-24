import 'package:intl/intl.dart';

class Distancedata{
  final DateTime time;
  final int value;

  Distancedata({required this.time, required this.value});

  Distancedata.fromJson(String date, Map<String, dynamic> json) :
      time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
      value = int.parse(json["value"]);

  @override
  String toString() {
    return 'StepData(time: $time, value: $value)';
  }//toString

  
}

