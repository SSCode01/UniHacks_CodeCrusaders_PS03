import 'package:flutter/material.dart';
import '../widgets/emoji_avatar.dart';
import '../widgets/funky_button.dart';
import 'prompt_results_screen.dart';

class DailyPromptScreen extends StatefulWidget {
  final String groupId;

  const DailyPromptScreen({super.key, required this.groupId});

  @override
  State<DailyPromptScreen> createState() => _DailyPromptScreenState();
}

class _DailyPromptScreenState extends State<DailyPromptScreen> {
  String? selectedMemberId;

  final List<Map<String, String>> members = [
    {'id': '1', 'name': 'You', 'avatar': '😎'},
    {'id': '2', 'name': 'Alex', 'avatar': '🤪'},
    {'id': '3', 'name': 'Sam', 'avatar': '🔥'},
    {'id': '4', 'name': 'Jordan', 'avatar': '✨'},
  ];

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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Question',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Vote to see results',
              style: TextStyle(
                color: Color(0xFFA1A1B5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Question
            const Text('🧟', style: TextStyle(fontSize: 70)),
            const SizedBox(height: 24),
            const Text(
              'Who would survive a zombie apocalypse?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Pick one member (choose wisely)',
              style: TextStyle(
                color: Color(0xFFA1A1B5),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 40),

            // Member Cards
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  final isSelected = selectedMemberId == member['id'];

                  return InkWell(
                    onTap: () =>
                        setState(() => selectedMemberId = member['id']),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFFFF006E), Color(0xFF8B5CF6)],
                              )
                            : null,
                        color: isSelected ? null : const Color(0xFF2D2D44),
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
                            EmojiAvatar(
                                emoji: member['avatar']!, size: 'lg'),
                            const SizedBox(height: 12),
                            Text(
                              member['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Vote Button
            SizedBox(
              width: double.infinity,
              child: FunkyButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PromptResultsScreen(groupId: widget.groupId),
                    ),
                  );
                },
                text: "Lock in my vote 🗳️",
                size: 'lg',
                disabled: selectedMemberId == null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
