import 'package:flutter/material.dart';

class NutritionInfoPage extends StatelessWidget {
  const NutritionInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutritional Status Explanation'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• Overnutrition',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 4),
            Text(
              'Overnutrition occurs when calorie intake consistently exceeds the body\'s energy expenditure. '
              'This can lead to excess fat accumulation over time.\n\n'
              '➤ Short-term effects:\n'
              '- Weight gain\n'
              '- Post-meal fatigue or sluggishness\n\n'
              '➤ Long-term effects:\n'
              '- Obesity\n'
              '- Type 2 diabetes\n'
              '- Cardiovascular diseases\n',
            ),
            SizedBox(height: 20),
            Text(
              '• Undernutrition',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 4),
            Text(
              'Undernutrition happens when energy intake is consistently lower than what the body requires. '
              'It can lead to nutrient deficiencies and muscle loss.\n\n'
              '➤ Short-term effects:\n'
              '- Fatigue and weakness\n'
              '- Difficulty concentrating\n\n'
              '➤ Long-term effects:\n'
              '- Malnutrition\n'
              '- Osteoporosis\n'
              '- Hormonal imbalances\n',
            ),
            SizedBox(height: 20),
            Text(
              '• Balanced Nutrition',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 4),
            Text(
              'Balanced nutrition occurs when calorie intake closely matches calorie expenditure. '
              'This is the ideal state for maintaining weight and supporting overall health.\n\n'
              '➤ Benefits:\n'
              '- Weight stability\n'
              '- Healthy body composition\n'
              '- Improved physical and mental well-being\n\n'
              'Note: Balance should be evaluated on a weekly average, not necessarily every single day.',
            ),
          ],
        ),
      ),
    );
  }
}
