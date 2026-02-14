import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'main_navigation.dart';
import 'profile_setup_screen.dart';

class DailyMoodScreen extends StatefulWidget {
  const DailyMoodScreen({super.key});

  @override
  State<DailyMoodScreen> createState() => _DailyMoodScreenState();
}

class _DailyMoodScreenState extends State<DailyMoodScreen> {
  final List<Map<String, dynamic>> moods = [
    {
      'emoji': '🔥',
      'label': 'On fire',
      'colors': [AppColors.primaryPink, AppColors.primaryOrange]
    },
    {
      'emoji': '😎',
      'label': 'Vibing',
      'colors': [AppColors.primaryBlue, Color(0xFF0066FF)]
    },
    {
      'emoji': '🤪',
      'label': 'Chaotic',
      'colors': [Color(0xFFC0FF00), Color(0xFF00FF88)]
    },
    {
      'emoji': '😴',
      'label': 'Exhausted',
      'colors': [AppColors.primaryPurple, AppColors.primaryPink]
    },
  ];

  void _selectMood(String label) {
    // Save mood selection
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Header
              const Text(
                "How's it going?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              const Text(
                "Pick your vibe for today",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFA1A1B5),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Mood Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: moods.length,
                itemBuilder: (context, index) {
                  final mood = moods[index];
                  return InkWell(
                    onTap: () => _selectMood(mood['label']),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: mood['colors'],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B263B),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              mood['emoji'],
                              style: const TextStyle(fontSize: 60),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              mood['label'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),

              // Skip Button
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileSetupScreen()),
                  );
                },
                child: const Text(
                  'Skip for now →',
                  style: TextStyle(
                    color: Color(0xFFA1A1B5),
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
