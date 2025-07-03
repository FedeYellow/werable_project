import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodDiaryCard extends StatefulWidget {
  const FoodDiaryCard({super.key});

  @override
  State<FoodDiaryCard> createState() => _FoodDiaryCardState();
}

class _FoodDiaryCardState extends State<FoodDiaryCard> {
  final dateFormat = DateFormat('yyyy-MM-dd');
  final displayFormat = DateFormat('EEE, MMM d, yyyy');

  DateTime selectedDate = DateTime.now();
  String selectedMeal = 'Breakfast';

  final meals = ['Breakfast', 'Lunch', 'Snack', 'Dinner'];

  Map<String, List<_FoodEntry>> mealEntries = {
    'Breakfast': [],
    'Lunch': [],
    'Snack': [],
    'Dinner': [],
  };

  int totalCaloriesIn = 0;

  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFoodEntries();
  }

  Future<void> _loadFoodEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'food_entries_${dateFormat.format(selectedDate)}';

    final savedData = prefs.getString(key);
    if (savedData == null) {
      // no data yet
      setState(() {
        mealEntries = {
          for (var meal in meals) meal: <_FoodEntry>[],
        };
        totalCaloriesIn = 0;
      });
      return;
    }

    final Map<String, dynamic> decoded = Map<String, dynamic>.from(
      Uri.splitQueryString(savedData)
    );

    Map<String, List<_FoodEntry>> loadedEntries = {};

    int total = 0;

    for (var meal in meals) {
      final entriesRaw = decoded[meal] as String?;
      if (entriesRaw == null || entriesRaw.isEmpty) {
        loadedEntries[meal] = [];
        continue;
      }

      final List<_FoodEntry> list = entriesRaw
          .split(';;')
          .map((e) {
            final parts = e.split('|');
            final name = parts[0];
            final cals = int.tryParse(parts[1]) ?? 0;
            total += cals;
            return _FoodEntry(name: name, calories: cals);
          })
          .toList();

      loadedEntries[meal] = list;
    }

    setState(() {
      mealEntries = loadedEntries;
      totalCaloriesIn = total;
    });
  }

  Future<void> _saveFoodEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'food_entries_${dateFormat.format(selectedDate)}';

    Map<String, String> toSave = {};

    for (var meal in meals) {
      final entries = mealEntries[meal]!;
      toSave[meal] = entries.map((e) => '${e.name}|${e.calories}').join(';;');
    }

    final encoded = Uri(queryParameters: toSave).query;

    await prefs.setString(key, encoded);
    await prefs.setInt('daily_calories_in_${dateFormat.format(selectedDate)}', totalCaloriesIn);
  }

  void _addFoodEntry() {
    final name = foodNameController.text.trim();
    final calories = int.tryParse(caloriesController.text.trim()) ?? 0;

    if (name.isEmpty || calories <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid food name and calories')),
      );
      return;
    }

    setState(() {
      mealEntries[selectedMeal]!.add(_FoodEntry(name: name, calories: calories));
      totalCaloriesIn += calories;
      foodNameController.clear();
      caloriesController.clear();
    });

    _saveFoodEntries();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _loadFoodEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date selector row
            Row(
              children: [
                Text(
                  'Food Diary - ${displayFormat.format(selectedDate)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectDate,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Meal selector dropdown
            DropdownButton<String>(
              value: selectedMeal,
              items: meals
                  .map((meal) => DropdownMenuItem(
                        value: meal,
                        child: Text(meal),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedMeal = value;
                  });
                }
              },
            ),

            const SizedBox(height: 12),

            Text(
              'Total Calories In: $totalCaloriesIn kcal',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 12),

            const Text('Entries:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),

            if (mealEntries[selectedMeal]!.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No entries for this meal.',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mealEntries[selectedMeal]!.length,
                itemBuilder: (context, index) {
                  final entry = mealEntries[selectedMeal]![index];
                  return ListTile(
                    title: Text(entry.name),
                    trailing: Text('${entry.calories} kcal'),
                    onLongPress: () {
                      // Optional: remove entry on long press
                      setState(() {
                        totalCaloriesIn -= entry.calories;
                        mealEntries[selectedMeal]!.removeAt(index);
                      });
                      _saveFoodEntries();
                    },
                  );
                },
              ),

            const Divider(height: 24),

            const Text('Add Food Entry:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),

            TextField(
              controller: foodNameController,
              decoration: const InputDecoration(labelText: 'Food Name'),
            ),

            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Calories'),
            ),

            const SizedBox(height: 12),

            Center(
              child: ElevatedButton(
                onPressed: _addFoodEntry,
                child: const Text('Add Entry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodEntry {
  final String name;
  final int calories;

  _FoodEntry({required this.name, required this.calories});
}
