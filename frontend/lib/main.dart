import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'test_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0D1B2A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const ChaosClubTester());
}

class ChaosClubTester extends StatelessWidget {
  const ChaosClubTester({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChaosClub - Screen Tester',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFF0D1B2A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF48FB1),
          brightness: Brightness.dark,
        ),
      ),
      home: const ScreenSelectorMenu(),
    );
  }
}
