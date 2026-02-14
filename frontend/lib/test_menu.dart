import 'package:flutter/material.dart';
import 'screens/daily_mood_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/create_group_screen.dart';
import 'screens/join_group_screen.dart';
import 'screens/group_dashboard_screen.dart';
import 'screens/daily_prompt_screen.dart';
import 'screens/prompt_results_screen.dart';
import 'screens/create_poll_screen.dart';
import 'screens/create_capsule_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/on_this_day_screen.dart';
import 'screens/main_navigation.dart';

class ScreenSelectorMenu extends StatelessWidget {
  const ScreenSelectorMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B263B),
        elevation: 0,
        title: const Text(
          '🧪 ChaosClub - Screen Tester',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Tap any screen to test it',
              style: TextStyle(
                color: Color(0xFFA1A1B5),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Navigation Screens
          _buildSectionHeader('🏠 Main Navigation'),
          _buildScreenButton(
            context,
            '🏠 Main Navigation (Bottom Nav)',
            const MainNavigation(),
            Colors.blue,
          ),
          _buildScreenButton(
            context,
            '🏡 Home Screen',
            const HomeScreen(),
            Colors.purple,
          ),
          _buildScreenButton(
            context,
            '📅 On This Day Screen',
            const OnThisDayScreen(),
            Colors.orange,
          ),
          _buildScreenButton(
            context,
            '👤 Profile Screen',
            const ProfileScreen(),
            Colors.cyan,
          ),
          _buildScreenButton(
            context,
            '🏆 Leaderboard Screen',
            const LeaderboardScreen(),
            Colors.amber,
          ),

          const SizedBox(height: 20),

          // Onboarding Screens
          _buildSectionHeader('✨ New Screens'),
          _buildScreenButton(
            context,
            '😊 Daily Mood Screen',
            const DailyMoodScreen(),
            Colors.pink,
          ),
          _buildScreenButton(
            context,
            '🎨 Profile Setup Screen',
            const ProfileSetupScreen(),
            Colors.teal,
          ),

          const SizedBox(height: 20),

          // Group Screens
          _buildSectionHeader('👥 Group Management'),
          _buildScreenButton(
            context,
            '➕ Create Group Screen',
            const CreateGroupScreen(),
            Colors.green,
          ),
          _buildScreenButton(
            context,
            '🎟️ Join Group Screen',
            const JoinGroupScreen(),
            Colors.indigo,
          ),
          _buildScreenButton(
            context,
            '📊 Group Dashboard',
            const GroupDashboardScreen(groupId: '1'),
            Colors.deepPurple,
          ),

          const SizedBox(height: 20),

          // Activity Screens
          _buildSectionHeader('🎮 Group Activities'),
          _buildScreenButton(
            context,
            '🧟 Daily Prompt Screen',
            const DailyPromptScreen(groupId: '1'),
            Colors.red,
          ),
          _buildScreenButton(
            context,
            '🏅 Prompt Results Screen',
            const PromptResultsScreen(groupId: '1'),
            Colors.yellow,
          ),
          _buildScreenButton(
            context,
            '📋 Create Poll Screen',
            const CreatePollScreen(groupId: '1'),
            Colors.blue,
          ),
          _buildScreenButton(
            context,
            '📦 Create Capsule Screen',
            const CreateCapsuleScreen(groupId: '1'),
            Colors.lime,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildScreenButton(
    BuildContext context,
    String title,
    Widget screen,
    Color accentColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor.withOpacity(0.2),
            accentColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: accentColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
