import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _loaderController;

  @override
  void initState() {
    super.initState();

    _loaderController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _loaderController.dispose();
    super.dispose();
  }

  Widget gradientText(String text, double size, FontWeight weight) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          AppColors.primaryPurple,
          AppColors.primaryPink,
        ],
      ).createShader(bounds),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: size,
          fontWeight: weight,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset(
              'assets/images/logo.png',
              width: 150,
            ),

            const SizedBox(height: 30),

            gradientText("ChaosClub", 34, FontWeight.w700),

            const SizedBox(height: 10),

            gradientText(
              "Built for chaotic friendships",
              16,
              FontWeight.w400,
            ),

            const SizedBox(height: 40),

            RotationTransition(
              turns: _loaderController,
              child: const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
