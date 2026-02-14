import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../utils/colors.dart';
import 'home_screen.dart';
import 'on_this_day_screen.dart';
import 'profile_screen.dart';
import 'leaderboard_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    OnThisDayScreen(),
    ProfileScreen(),
    LeaderboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1B263B),
          border: Border(
            top: BorderSide(
              color: Color(0xFF2D2D44),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: SalomonBottomBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              selectedItemColor: AppColors.primaryPink,
              unselectedItemColor: const Color(0xFFA1A1B5),
              backgroundColor: Colors.transparent,
              items: [
                SalomonBottomBarItem(
                  icon: const Icon(Icons.home_rounded),
                  title: const Text('Home'),
                  selectedColor: AppColors.primaryPink,
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.calendar_today_rounded),
                  title: const Text('This Day'),
                  selectedColor: const Color(0xFF00F5FF),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.person_rounded),
                  title: const Text('Profile'),
                  selectedColor: AppColors.primaryPurple,
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.emoji_events_rounded),
                  title: const Text('Leaderboard'),
                  selectedColor: const Color(0xFFC0FF00),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
