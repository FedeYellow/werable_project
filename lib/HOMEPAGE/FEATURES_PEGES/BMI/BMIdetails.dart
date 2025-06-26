import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

// COSECHA

class BMIDetails extends StatelessWidget {
  final double bmi;

  const BMIDetails({super.key, required this.bmi});

  String getStatus(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  String getRecommendations(String status) {
    switch (status) {
      case 'Underweight':
        return 'Increase your calorie intake with nutritious, protein-rich foods. Strength training and consulting a dietitian are recommended.';
      case 'Normal':
        return 'Maintain your healthy weight through balanced nutrition and regular physical activity. Routine check-ups are beneficial';
      case 'Overweight':
        return 'Consider reducing portion sizes, improving diet quality, and increasing physical activity. Seek guidance from a healthcare provider if needed.';
      case 'Obese':
        return 'There is a high risk of chronic diseases. Consult a healthcare professional to create a personalized health improvement plan.';
      default:
        return '';
    }
  }

  String getHealthRisks(String status) {
    switch (status) {
      case 'Underweight':
        return 'Increased risk of anemia, osteoporosis, weakened immune system and fertility issues.';
      case 'Normal':
        return 'Low health risks. Continue maintaining healthy lifestyle habits.';
      case 'Overweight':
        return 'Higher risk of high blood pressure, elevated cholesterol, type 2 diabetes and joint problems.';
      case 'Obese':
        return 'High risk of heart disease, type 2 diabetes, sleep apnea, certain cancers and reduced life expectancy.';
      default:
        return '';
    }
  }

  List<String> getRecommendedFoods(String status) {
    switch (status) {
      case 'Underweight':
        return [
          'Nuts and seeds (walnuts, almonds)',
          'Avocado',
          'Whole grain bread',
          'Pasta and rice',
          'Full-fat cheese and yogurt',
          'High-calorie smoothies',
        ];
      case 'Normal':
        return [
          'Fresh fruits and vegetables',
          'Legumes (beans, lentils)',
          'Whole grains',
          'Lean proteins (chicken, fish)',
          'Healthy oils (olive, sunflower)',
        ];
      case 'Overweight':
        return [
          'Leafy green vegetables',
          'Lean proteins',
          'Low-sugar fruits',
          'Quinoa, oats',
          'Steamed or baked foods',
        ];
      case 'Obese':
        return [
          'Raw or steamed vegetables without oil',
          'Low-fat legumes',
          'Moderate fruit (especially low in sugar)',
          'Water, unsweetened herbal teas',
          'Avoid ultra-processed foods',
        ];
      default:
        return [];
    }
  }


  List<String> getSuggestedActivities(String status) {
    switch (status) {
      case 'Underweight':
        return [
          'Yoga or Pilates',
          'Light walking',
          'Bodyweight strength exercises',
          'Stretching routines',
        ];
      case 'Normal':
        return [
          'Running or jogging',
          'Swimming',
          'Moderate strength training',
          'Recreational cycling',
        ];  
      case 'Overweight':
        return [
          'Walking 30–60 minutes daily',
          'Aqua aerobics',
          'Low-impact exercise',
          'Supervised training sessions',
        ];
      case 'Obese':
        return [
          'Gentle exercises: walking, swimming',
          'Low-resistance stationary bike',
          'Supervised physical therapy',
          'Joint mobility movements',
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = getStatus(bmi);
    final recommendations = getRecommendations(status);
    final risks = getHealthRisks(status);
    final foods = getRecommendedFoods(status);
    final activities = getSuggestedActivities(status);


    return Scaffold(
      appBar: AppBar(title: const Text("BMI Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(
              height: 250,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 10,
                    maximum: 40,
                    ranges: <GaugeRange>[
                      GaugeRange(startValue: 10, endValue: 18.5, color: Colors.blue),
                      GaugeRange(startValue: 18.5, endValue: 25, color: Colors.green),
                      GaugeRange(startValue: 25, endValue: 30, color: Colors.orange),
                      GaugeRange(startValue: 30, endValue: 40, color: Colors.red),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(value: bmi),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Text(
                          'BMI: ${bmi.toStringAsFixed(1)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        angle: 90,
                        positionFactor: 0.5,
                      )
                    ],
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 5),
            Row(
              children: [
                const Text('Current status: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // const - asi flutter no lo tiene que volver a hacer siempre - es fijo
                Text(status, style: TextStyle(fontSize: 16)),
              ],),
            //Text("Stato attuale: $status", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("✅ Recommendations:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(recommendations),
            const SizedBox(height: 10),
            Text("⚠️ Health risks:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(risks),
            const SizedBox(height: 10),
            Text("🍎 Recommended foods:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...foods.map((food) => Text("• $food")).toList(),
            const SizedBox(height: 10),
            Text("🏃 Suggested physical activities:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...activities.map((activity) => Text("• $activity")).toList(),
          ],
        ),
      ),
    );
  }
}
