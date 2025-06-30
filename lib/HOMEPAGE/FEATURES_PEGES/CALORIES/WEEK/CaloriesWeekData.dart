import 'package:intl/intl.dart';

class CaloriesWeekData {
  final DateTime date; // Giorno completo (solo data)
  final DateTime time; // Data e ora precise
  final int value;     // Calorie (arrotondate)

  CaloriesWeekData({
    required this.date,
    required this.time,
    required this.value,
  });

  /// Costruttore per i dati giornalieri con la data passata separatamente
  factory CaloriesWeekData.fromJsonWithDate(String dateStr, Map<String, dynamic> json) {
    final String timeStr = json['time'];
    final String valueStr = json['value'];

    final DateTime fullDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$dateStr $timeStr');
    final DateTime dateOnly = DateFormat('yyyy-MM-dd').parse(dateStr);
    final int parsedValue = double.parse(valueStr).round();

    return CaloriesWeekData(
      date: dateOnly,
      time: fullDateTime,
      value: parsedValue,
    );
  }

  @override
  String toString() =>
      'CaloriesWeekData(date: ${DateFormat('yyyy-MM-dd').format(date)}, '
      'time: ${DateFormat('HH:mm:ss').format(time)}, value: $value)';
}
