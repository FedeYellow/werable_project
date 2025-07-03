import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/BMI/BMImodel.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/DELTA_CAlORIES/Delta.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/FOOD_DIARY/DiaryCard.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/WEEK/CaloriesChartWeekCard.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CART/CartPage.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/DISTANCE/DistanceCard.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/MAP/map_card.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/PROFILE_CARD/profile_cards.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/RECOMMENDED_CALORIES/PalCard.dart';
import 'package:werable_project/LOGIN/LoginPage.dart';



class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove('access');
    await sp.remove('refresh');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          )
        ],
      ),
      body: FutureBuilder<Map<String, String>>(
        future: ProfileCard.loadProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          final profile = snapshot.data ?? {};

          if (profile.isEmpty) {
            return Center(child: Text('Nessun profilo utente trovato.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ProfileCard(
                  firstName: profile['firstName'] ?? '',
                  lastName: profile['lastName'] ?? '',
                  age: profile['age'] ?? '',
                  gender: profile['gender'] ?? '',
                  height: profile['height'] ?? '',
                  weight: profile['weight'] ?? '',
                ),
                
                SizedBox(height: 30), //Map Card
                MapCard(),

                SizedBox(height: 20),
                BMICard(),

                DistanceCard(),
                CaloricRequirementCard(),
                WeeklyCaloriesChartCard(),
                WeeklyCaloriesDeltaChartCard(),
                FoodDiaryCard(),
              

              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, MaterialPageRoute(builder: (_) => CartPage()),
          );
        },
        child: Icon(Icons.shopping_cart_checkout),
        ),
    );
  }
}