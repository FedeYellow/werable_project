import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileCard extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String age;
  final String gender; // "M" o "F"
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
    final Map<String, String> profile = decoded.map((key, value) => MapEntry(key, value.toString()));

    

    return profile;
  }

  

  @override
  Widget build(BuildContext context) {
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
