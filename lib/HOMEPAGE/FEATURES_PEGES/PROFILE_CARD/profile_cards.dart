import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String age;
  final String gender; // "male" o "female"
  final String height; // in cm
  final String weight; // in kg

  const ProfileCard({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
  });

  static Future<Map<String, String>> loadProfile() async {
    final sp = await SharedPreferences.getInstance();
    final jsonString = sp.getString('profile');
    if (jsonString == null) return {};
    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((key, value) => MapEntry(key, value.toString()));
  }

  /// 🔥 Calcola il metabolismo basale usando la formula di Mifflin-St Jeor
  int calculateBMR() {
    final intAge = int.tryParse(age) ?? 0;
    final doubleWeight = double.tryParse(weight) ?? 0.0;
    final doubleHeight = double.tryParse(height) ?? 0.0;

    if (gender.toLowerCase() == 'm' ) {
      return (10 * doubleWeight + 6.25 * doubleHeight - 5 * intAge + 5).round();
    } else if (gender.toLowerCase() == 'f' ) {
      return (10 * doubleWeight + 6.25 * doubleHeight - 5 * intAge - 161).round();
    } else {
      return 0; // Genere sconosciuto
    }
  }

  @override
  Widget build(BuildContext context) {
    final bmr = calculateBMR();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$firstName $lastName',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Età: $age'),
                  Text('Sesso: $gender'),
                  Text('Altezza: $height cm'),
                  Text('Peso: $weight kg'),
                  const SizedBox(height: 8),
                  Text('Metabolismo Basale: $bmr kcal'),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ProfilePicture(
              name: "$firstName $lastName",
              radius: 35,
              fontsize: 20,
            )
          ],
        ),
      ),
    );
  }
}
