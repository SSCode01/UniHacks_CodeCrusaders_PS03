import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const ChaosClub());
}

class ChaosClub extends StatelessWidget {
  const ChaosClub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChaosClub',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const SplashScreen(),
    );
  }
}



