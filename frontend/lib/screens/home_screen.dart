import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'create_group_screen.dart';
import 'notifications_screen.dart';
import 'on_this_day_screen.dart';
import 'group_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  // Mock user data - Replace with your actual user data/state management
  final String userName = 'chaos_king';
  final int userStreak = 5;
  final int userPoints = 820;
  final String userAvatar = 'assets/images/avatar1.png';
  
  // Mock groups data - Replace with your actual groups data/state management
  final List<Map<String, dynamic>> groups = [
    {
      'id': '1',
      'name': 'Squad Goals',
      'emoji': '🔥',
      'members': 4,
      'chaosLevel': 'High',
    },
    {
      'id': '2',
      'name': 'Night Owls',
      'emoji': '🦉',
      'members': 3,
      'chaosLevel': 'Medium',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0D1B2A).withOpacity(0.95),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF2D2D44),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hey $userName! 👋',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Time to vibe check your squad',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFA1A1B5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B263B),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.notifications_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.primaryPink,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
          child: Column(
            children: [
              // Today's Prompt Card
              _buildAnimatedCard(
                delay: 0,
                child: _GradientCard(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryPink, AppColors.primaryPurple],
                  ),
                  onTap: () {
                    // Navigate to prompt voting
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Today\'s Prompt',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFA1A1B5),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Who would survive a zombie apocalypse? 🧟',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tap to vote',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF00F5FF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text('🎯', style: TextStyle(fontSize: 40)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Stats Row
              _buildAnimatedCard(
                delay: 100,
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.local_fire_department_rounded,
                        iconColor: AppColors.primaryPink,
                        value: userStreak.toString(),
                        label: 'Day Streak',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        emoji: '⭐',
                        value: userPoints.toString(),
                        label: 'Total Points',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // On This Day Card
              _buildAnimatedCard(
                delay: 150,
                child: _GradientCard(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFF9A44), Color(0xFFFF4D4D)],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnThisDayScreen(),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'On This Day',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Relive old chaos',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'View memories 📸',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text('🗓️', style: TextStyle(fontSize: 40)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Your Squads Section Header
              _buildAnimatedCard(
                delay: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your Squads',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateGroupScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primaryPink, AppColors.primaryPurple],
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Group Cards
              ...groups.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> group = entry.value;
                return _buildAnimatedCard(
                  delay: 250 + (index * 50),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _GroupCard(
                      emoji: group['emoji'],
                      name: group['name'],
                      memberCount: group['members'],
                      chaosLevel: group['chaosLevel'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupDashboardScreen(
                              groupId: group['id'],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 12),

              // Time Capsule Card
              _buildAnimatedCard(
                delay: 350,
                child: _GradientCard(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryBlue, AppColors.primaryPurple],
                  ),
                  onTap: () {
                    // Navigate to time capsule
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.inventory_2_rounded,
                              color: AppColors.primaryBlue,
                              size: 32,
                              ),
                            const SizedBox(height: 8),
                            const Text(
                              'Time Capsule',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Unlocks in 2 days 👀',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFA1A1B5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text('📦', style: TextStyle(fontSize: 50)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({required int delay, required Widget child}) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            delay / 500,
            (delay + 200) / 500,
            curve: Curves.easeOut,
          ),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              delay / 500,
              (delay + 200) / 500,
              curve: Curves.easeOut,
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}

// Gradient Card Widget
class _GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final VoidCallback? onTap;

  const _GradientCard({
    required this.child,
    required this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      ),
    );
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String? emoji;
  final String value;
  final String label;

  const _StatCard({
    this.icon,
    this.iconColor,
    this.emoji,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2D2D44),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Icon(icon, color: iconColor, size: 24)
          else if (emoji != null)
            Text(emoji!, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFA1A1B5),
            ),
          ),
        ],
      ),
    );
  }
}

// Group Card Widget
class _GroupCard extends StatelessWidget {
  final String emoji;
  final String name;
  final int memberCount;
  final String chaosLevel;
  final VoidCallback? onTap;

  const _GroupCard({
    required this.emoji,
    required this.name,
    required this.memberCount,
    required this.chaosLevel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1B263B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF2D2D44),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.people_rounded,
                        color: Color(0xFFA1A1B5),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$memberCount members',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFA1A1B5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Chaos Level',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFFA1A1B5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$chaosLevel 🔥',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPink,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
