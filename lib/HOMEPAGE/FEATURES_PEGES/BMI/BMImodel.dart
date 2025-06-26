import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:convert';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/BMI/BMIDetails.dart';

class BMICard extends StatefulWidget {
  const BMICard({super.key});

  @override
  State<BMICard> createState() => _BMICardState();
}

class _BMICardState extends State<BMICard> {
  double? bmi;
  String status = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final sp = await SharedPreferences.getInstance();
    final data = sp.getString('profile');
    if (data == null) return;

    final Map<String, dynamic> profile = jsonDecode(data);
    final double? weight = double.tryParse(profile['weight'] ?? '');
    final double? heightCm = double.tryParse(profile['height'] ?? '');
    final double? heightM = heightCm != null ? heightCm / 100 : null;

    if (weight != null && heightM != null && heightM > 0) {
      final calculatedBmi = weight / (heightM * heightM);
      setState(() {
        bmi = calculatedBmi;
        status = _classifyBMI(calculatedBmi);
      });
    }
  }

  String _classifyBMI(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: bmi == null
            ? const Text('BMI not available: missing or invalid data')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Body Mass Index (BMI)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Etichette sopra il gauge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Underweight', style: TextStyle(fontSize: 12)),
                      Text('Normal', style: TextStyle(fontSize: 12)),
                      Text('Overweight', style: TextStyle(fontSize: 12)),
                      Text('Obese', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  SfLinearGauge(
                    minimum: 10,
                    maximum: 40,
                    showTicks: false,
                    showLabels: false,
                    animateAxis: true,
                    ranges: const <LinearGaugeRange>[
                      LinearGaugeRange(
                        startValue: 10,
                        endValue: 18.5,
                        color: Colors.blue,
                      ),
                      LinearGaugeRange(
                        startValue: 18.5,
                        endValue: 25,
                        color: Colors.green,
                      ),
                      LinearGaugeRange(
                        startValue: 25,
                        endValue: 30,
                        color: Colors.orange,
                      ),
                      LinearGaugeRange(
                        startValue: 30,
                        endValue: 40,
                        color: Colors.red,
                      ),
                    ],
                    markerPointers: <LinearMarkerPointer>[
                      LinearWidgetPointer(
                        value: bmi!,
                        position: LinearElementPosition.outside,
                        child: const Icon(Icons.arrow_drop_down, size: 28),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Text('BMI: ${bmi!.toStringAsFixed(1)} - Status: $status'), // valor de BMI redondeado a 1 decimal + estado de salud
                
                  // COSECHA --> BOTON PARA MAS INFO
                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BMIDetails(bmi: bmi!)));
                      },
                      child: Text('More information'),
                    )

                  )
                
                ],
              ),
      ),
    );
  }
}
