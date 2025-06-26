import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CALORIES/CaloriesProvider.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/CART/ProviderCart.dart';
import 'package:werable_project/HOMEPAGE/FEATURES_PEGES/DISTANCE/DistanceProvider.dart';
import 'package:werable_project/HOMEPAGE/HomePage.dart';
import 'package:werable_project/LOGIN/LoginPage.dart';
import 'package:werable_project/LOGIN/RegistrationPage.dart';


void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => DistanceProvider()),
      ChangeNotifierProvider(create: (_) => Caloriesprovider()),  
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Impact Auth Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Future<bool> _hasValidToken() async {
    final sp = await SharedPreferences.getInstance();
    final access = sp.getString('access');
    return access != null && access.isNotEmpty;
  }

  void _navigateAsUser(BuildContext context) async {
    final hasToken = await _hasValidToken();
    if (hasToken) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void _navigateToRegistration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationSelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleziona tipo di accesso')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _navigateAsUser(context),
              child: const Text('Accedi come Utente'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pagina venditore ancora non disponibile'),
                  ),
                );
              },
              child: const Text('Accedi come Venditore'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _navigateToRegistration(context),
              child: const Text('Registrati'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationSelectionPage extends StatefulWidget {
  const RegistrationSelectionPage({Key? key}) : super(key: key);

  @override
  State<RegistrationSelectionPage> createState() => _RegistrationSelectionPageState();
}

class _RegistrationSelectionPageState extends State<RegistrationSelectionPage> {
  bool isUser = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrazione')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Registrati come Utente'),
                Switch(
                  value: isUser,
                  onChanged: (value) {
                    setState(() {
                      isUser = value;
                    });
                  },
                ),
                const Text('Venditore'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isUser) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegistrationPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Registrazione come venditore non disponibile'),
                    ),
                  );
                }
              },
              child: const Text('Procedi'),
            ),
          ],
        ),
      ),
    );
  }
}
