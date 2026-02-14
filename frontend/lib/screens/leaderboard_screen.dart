import 'package:flutter/material.dart';
import '../utils/colors.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _globalUsers = [
    {'rank': 1, 'name': 'Chaos Queen', 'points': 2450, 'avatar': '👑', 'change': 'up'},
    {'rank': 2, 'name': 'Vibe Master', 'points': 2320, 'avatar': '😎', 'change': 'down'},
    {'rank': 3, 'name': 'Pixel Pro', 'points': 2180, 'avatar': '👾', 'change': 'stable'},
    {'rank': 4, 'name': 'Night Owl', 'points': 1950, 'avatar': '🦉', 'change': 'up'},
    {'rank': 5, 'name': 'Early Bird', 'points': 1890, 'avatar': '🐦', 'change': 'down'},
    {'rank': 6, 'name': 'Meme Lord', 'points': 1750, 'avatar': '🐸', 'change': 'stable'},
    {'rank': 7, 'name': 'Code Ninja', 'points': 1620, 'avatar': '💻', 'change': 'up'},
  ];

  final List<Map<String, dynamic>> _squadUsers = [
    {'rank': 1, 'name': 'You', 'points': 820, 'avatar': '👋', 'change': 'up'},
    {'rank': 2, 'name': 'Alex', 'points': 780, 'avatar': '🎸', 'change': 'down'},
    {'rank': 3, 'name': 'Sam', 'points': 650, 'avatar': '🎨', 'change': 'stable'},
    {'rank': 4, 'name': 'Jordan', 'points': 540, 'avatar': '🏀', 'change': 'stable'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryPink,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFFA1A1B5),
          tabs: const [
            Tab(text: 'Global'),
            Tab(text: 'My Squad'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboardList(_globalUsers),
          _buildLeaderboardList(_squadUsers),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList(List<Map<String, dynamic>> users) {
    if (users.isEmpty) return const SizedBox();

    final topThree = users.take(3).toList();
    final others = users.skip(3).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 2nd Place
                if (topThree.length > 1)
                  _buildPodiumItem(topThree[1], 2, 140, const Color(0xFFC0C0C0)),
                
                // 1st Place
                if (topThree.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _buildPodiumItem(topThree[0], 1, 170, const Color(0xFFFFD700)),
                  ),
                
                // 3rd Place
                if (topThree.length > 2)
                  _buildPodiumItem(topThree[2], 3, 120, const Color(0xFFCD7F32)),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final user = others[index];
              return _buildRankItem(user);
            },
            childCount: others.length,
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }

  Widget _buildPodiumItem(Map<String, dynamic> user, int rank, double height, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFF1B263B),
          child: Text(user['avatar'], style: const TextStyle(fontSize: 24)),
        ),
        const SizedBox(height: 8),
        Text(
          user['name'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(0.3),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border(
              top: BorderSide(color: color, width: 2),
              left: BorderSide(color: color.withOpacity(0.5), width: 1),
              right: BorderSide(color: color.withOpacity(0.5), width: 1),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${user['points']}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRankItem(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2D2D44),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              '${user['rank']}',
              style: const TextStyle(
                color: Color(0xFFA1A1B5),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF2D2D44),
            child: Text(user['avatar'], style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              user['name'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user['points']} pts',
                style: TextStyle(
                  color: AppColors.primaryPink,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Icon(
                user['change'] == 'up'
                    ? Icons.arrow_drop_up_rounded
                    : user['change'] == 'down'
                        ? Icons.arrow_drop_down_rounded
                        : Icons.remove_rounded,
                color: user['change'] == 'up'
                    ? Colors.greenAccent
                    : user['change'] == 'down'
                        ? Colors.redAccent
                        : const Color(0xFFA1A1B5),
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
