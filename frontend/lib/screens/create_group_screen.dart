import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/funky_button.dart';
import 'group_dashboard_screen.dart';
import 'join_group_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  String selectedEmoji = '🔥';

  final List<String> emojis = [
    '🔥',
    '💀',
    '🦄',
    '🌈',
    '👾',
    '🎮',
    '🍕',
    '🎭',
    '⚡',
    '🌙',
    '🦉',
    '🐉'
  ];

  void _createGroup() {
    if (_groupNameController.text.isEmpty) return;
    
    // Navigate to Group Dashboard with the new group details
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GroupDashboardScreen(
          groupId: 'new_group_${DateTime.now().millisecondsSinceEpoch}',
          groupName: _groupNameController.text,
          groupEmoji: selectedEmoji,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Squad',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Start a new chaos hub',
              style: TextStyle(
                color: Color(0xFFA1A1B5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji Selection
            const Text(
              'Pick a group emoji',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            // Selected Emoji Display
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryPink, AppColors.primaryPurple],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    selectedEmoji,
                    style: const TextStyle(fontSize: 60),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Emoji Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: emojis.length,
              itemBuilder: (context, index) {
                final emoji = emojis[index];
                final isSelected = emoji == selectedEmoji;

                return InkWell(
                  onTap: () => setState(() => selectedEmoji = emoji),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                AppColors.primaryPink,
                                AppColors.primaryPurple
                              ],
                            )
                          : null,
                      color: isSelected ? null : const Color(0xFF1B263B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Group Name
            const Text(
              'Group name',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1B263B),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF2D2D44),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _groupNameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "The Chaos Crew",
                  hintStyle: TextStyle(color: Color(0xFFA1A1B5)),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),

            const SizedBox(height: 24),

            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1B263B),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF2D2D44),
                  width: 1,
                ),
              ),
              child: const Row(
                children: [
                  Text('💡', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "After creating, you'll get an invite code to share with your squad. Keep it secret, keep it safe.",
                      style: TextStyle(
                        color: Color(0xFFA1A1B5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Create Button
            SizedBox(
              width: double.infinity,
              child: FunkyButton(
                onPressed: _createGroup,
                text: "Create Squad 🚀",
                size: 'lg',
                disabled: _groupNameController.text.isEmpty,
              ),
            ),

            const SizedBox(height: 16),

            // Join Group Link
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JoinGroupScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Or join an existing squad →',
                  style: TextStyle(
                    color: Color(0xFF00F5FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }
}
