import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const SizedBox(height: 40),

              const Text(
                "🎉",
                style: TextStyle(fontSize: 48),
              ),

              const SizedBox(height: 20),

              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    AppColors.primaryPink,
                    AppColors.primaryPurple,
                  ],
                ).createShader(bounds),
                child: const Text(
                  "Join the party!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Create your ChaosClub account",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 40),

              // 🔥 USERNAME
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Username",
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon:
                        Icon(Icons.alternate_email, color: Colors.white54),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 EMAIL
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon:
                        Icon(Icons.email_outlined, color: Colors.white54),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 🔒 PASSWORD
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const TextField(
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon:
                        Icon(Icons.lock_outline, color: Colors.white54),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // 🔹 SIGNUP BUTTON
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryPink,
                      AppColors.primaryPurple,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Start the chaos 🚀",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D1B2A),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 LOGIN NAVIGATION
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already a member? ",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: AppColors.primaryPink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
