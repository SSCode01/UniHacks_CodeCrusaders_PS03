import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/gradient_card.dart';
import '../widgets/emoji_avatar.dart';
import 'group_chat_screen_hardcoded.dart';
import 'create_poll_screen.dart';
import 'create_capsule_screen.dart';
import 'daily_prompt_screen.dart';

class GroupDashboardScreen extends StatefulWidget {
  final String groupId;

  const GroupDashboardScreen({super.key, required this.groupId});

  @override
  State<GroupDashboardScreen> createState() => _GroupDashboardScreenState();
}

class _GroupDashboardScreenState extends State<GroupDashboardScreen> {
  String activeTab = 'today';

  // Mock data - Replace with actual API calls
  final Map<String, dynamic> group = {
    'name': 'Squad Goals',
    'emoji': '🔥',
    'chaosLevel': 'High',
    'members': [
      {'id': '1', 'name': 'You', 'avatar': '😎', 'isAdmin': true},
      {'id': '2', 'name': 'Alex', 'avatar': '🤪', 'isAdmin': false},
      {'id': '3', 'name': 'Sam', 'avatar': '🔥', 'isAdmin': false},
      {'id': '4', 'name': 'Jordan', 'avatar': '✨', 'isAdmin': false},
    ],
  };

  // Current user data - Replace with actual data from your auth/storage
  final Map<String, String> currentUser = {
    'id': '1',
    'name': 'You',
    'username': 'chaos_king',
    'emoji': '😎',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1B263B), Color(0xFF0D1B2A)],
                ),
                border: Border(
                  bottom: BorderSide(color: Color(0xFF2D2D44), width: 1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Back Button and Title
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          group['emoji'],
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                group['name'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Chaos level: ${group['chaosLevel']} 🔥',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryPink,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Chat Button
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryPink,
                                AppColors.primaryPurple
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.chat_rounded),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GroupChatScreenHardcoded(
                                    groupId: widget.groupId,
                                    groupName: group['name'],
                                    groupEmoji: group['emoji'],
                                    currentUserId: currentUser['id']!,
                                    currentUserName: currentUser['username']!,
                                    currentUserEmoji: currentUser['emoji']!,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Members
                    Row(
                      children: [
                        ...group['members']
                            .map<Widget>((member) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Stack(
                                    children: [
                                      EmojiAvatar(
                                          emoji: member['avatar'], size: 'sm'),
                                      if (member['isAdmin'])
                                        const Positioned(
                                          top: -2,
                                          right: -2,
                                          child: Icon(Icons.star,
                                              color: Color(0xFFC0FF00),
                                              size: 16),
                                        ),
                                    ],
                                  ),
                                ))
                            .toList(),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2D2D44),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.add,
                                color: Color(0xFFA1A1B5), size: 20),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Tabs
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildTab('today', 'Today', Icons.bolt),
                          const SizedBox(width: 8),
                          _buildTab('games', 'Games', Icons.sports_esports),
                          const SizedBox(width: 8),
                          _buildTab('memories', 'Memories', Icons.camera_alt),
                          const SizedBox(width: 8),
                          _buildTab('leaderboard', 'Ranks', Icons.emoji_events),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildTabContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String id, String label, IconData icon) {
    final isActive = activeTab == id;
    return InkWell(
      onTap: () => setState(() => activeTab = id),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: [AppColors.primaryPink, AppColors.primaryPurple],
                )
              : null,
          color: isActive ? null : const Color(0xFF1B263B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isActive ? Colors.white : const Color(0xFFA1A1B5),
                size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFFA1A1B5),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (activeTab) {
      case 'today':
        return Column(
          children: [
            // Chat Card (NEW!)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupChatScreenHardcoded(
                      groupId: widget.groupId,
                      groupName: group['name'],
                      groupEmoji: group['emoji'],
                      currentUserId: currentUser['id']!,
                      currentUserName: currentUser['username']!,
                      currentUserEmoji: currentUser['emoji']!,
                    ),
                  ),
                );
              },
              child: GradientCard(
                gradient: 'purple',
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Group Chat",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Chat with your squad in real-time",
                            style: TextStyle(
                              color: Color(0xFFA1A1B5),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.people,
                                    color: Colors.white, size: 12),
                                SizedBox(width: 4),
                                Text(
                                  "4 online",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text('💬', style: TextStyle(fontSize: 40)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Today's Question
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DailyPromptScreen(groupId: widget.groupId),
                  ),
                );
              },
              child: GradientCard(
                gradient: 'pink',
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Today's Question",
                            style: TextStyle(
                              color: Color(0xFFA1A1B5),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Who would survive a zombie apocalypse?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "👉 Vote now",
                            style: TextStyle(
                              color: Color(0xFF00F5FF),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text('🧟', style: TextStyle(fontSize: 40)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Create Poll
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreatePollScreen(groupId: widget.groupId),
                  ),
                );
              },
              child: GradientCard(
                gradient: 'blue',
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Create a Poll",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Ask your squad anything",
                            style: TextStyle(
                              color: Color(0xFFA1A1B5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text('📊', style: TextStyle(fontSize: 40)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Time Capsule
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateCapsuleScreen(groupId: widget.groupId),
                  ),
                );
              },
              child: GradientCard(
                gradient: 'lime',
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Time Capsule",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Capture this moment",
                            style: TextStyle(
                              color: Color(0xFFA1A1B5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text('📦', style: TextStyle(fontSize: 40)),
                  ],
                ),
              ),
            ),
          ],
        );

      case 'games':
        return GradientCard(
          gradient: 'purple',
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Mini Games Hub",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Play & compete with your squad",
                      style: TextStyle(
                        color: Color(0xFFA1A1B5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Text('🎮', style: TextStyle(fontSize: 40)),
            ],
          ),
        );

      case 'memories':
        return Column(
          children: [
            GradientCard(
              gradient: 'orange',
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Squad Memories",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Relive the best moments",
                          style: TextStyle(
                            color: Color(0xFFA1A1B5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text('📸', style: TextStyle(fontSize: 40)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Unlocked Capsules
            GradientCard(
              gradient: 'lime',
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Unlocked Capsules",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "3 capsules waiting",
                          style: TextStyle(
                            color: Color(0xFFA1A1B5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text('🎁', style: TextStyle(fontSize: 40)),
                ],
              ),
            ),
          ],
        );

      case 'leaderboard':
        return Column(
          children: [
            GradientCard(
              gradient: 'gold',
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Squad Rankings",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Who's the chaos champion?",
                          style: TextStyle(
                            color: Color(0xFFA1A1B5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text('🏆', style: TextStyle(fontSize: 40)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Top 3 members preview
            ...List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2D2D44)),
                ),
                child: Row(
                  children: [
                    Text(
                      ['🥇', '🥈', '🥉'][index],
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),
                    EmojiAvatar(
                      emoji: group['members'][index]['avatar'],
                      size: 'sm',
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        group['members'][index]['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '${[1250, 980, 750][index]} pts',
                      style: TextStyle(
                        color: AppColors.primaryPink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

      default:
        return const Center(
          child: Text(
            'Coming soon!',
            style: TextStyle(color: Color(0xFFA1A1B5)),
          ),
        );
    }
  }
}