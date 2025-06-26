import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';
import 'dart:convert';
import 'package:werable_project/LOGIN/birth_date.dart'; // cosecha
import 'package:werable_project/LOGIN/age_utils.dart'; // cosecha

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  //*****final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  DateTime? _selectedBirthDate; // COSECHA

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    //******final age = _ageController.text.trim();
    final gender = _genderController.text.trim();
    final height = _heightController.text.trim();
    final weight = _weightController.text.trim();

    if ([username, password, confirm, firstName, lastName, gender, height, weight].any((e) => e.isEmpty)) { // he quitado age detras de lastname
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // validación --> evitar que el user se registre sin haber seleccionado una fecha de nacimiento
    if (_selectedBirthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your birth date')),
      );
      return;
    }

    final birthDateStr = _selectedBirthDate!.toIso8601String(); // convertir la fecha a una cadena de texto estandard - pq sharedPreferences solo puede guardar strings
    final calculatedAge = calculateAge(birthDateStr);

    final profile = {
      'firstName': firstName,
      'lastName': lastName,
      //****** */'age': age,
      'age': calculatedAge.toString(),
      'gender': gender,
      'height': height,
      'weight': weight
    };

    final sp = await SharedPreferences.getInstance();
    await sp.setString('profile', jsonEncode(profile));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration successful!')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: 'Username')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            TextField(controller: _confirmController, decoration: InputDecoration(labelText: 'Confirm Password'), obscureText: true),
            TextField(controller: _firstNameController, decoration: InputDecoration(labelText: 'First Name')),
            TextField(controller: _lastNameController, decoration: InputDecoration(labelText: 'Last Name')),
            //******TextField(controller: _ageController, decoration: InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
            
            // COSECHA
            const SizedBox(height: 12),
            BirthDatePicker(
              onDateSelected: (date) {
                _selectedBirthDate = date;
              },
            ),


            //TextField(controller: _genderController, decoration: InputDecoration(labelText: 'Gender')),
            
            // COSECHA --> SOLO DOS OPCIONES PARA EL GÉNERO
            DropdownButtonFormField<String>( // crea formulario desplegable - solo acepta string como tipo de valor
              value: _genderController.text.isNotEmpty ? _genderController.text : null, // si gender no es empty ... - si no null
              items: [
                const DropdownMenuItem(value: 'F', child: Text('F')), // const - pq nunca cambian - para que flutter no los vuelva a crear cada vez
                const DropdownMenuItem(value: 'M', child: Text('M')),
              ],
              onChanged: (value) {
                setState(() {
                  _genderController.text = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Gender'),
            ),

            TextField(controller: _heightController, decoration: InputDecoration(labelText: 'Height (cm)'), keyboardType: TextInputType.number),
            TextField(controller: _weightController, decoration: InputDecoration(labelText: 'Weight (kg)'), keyboardType: TextInputType.number),
            
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
