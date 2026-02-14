import 'package:flutter/material.dart';
import '../widgets/emoji_avatar.dart';

class PromptResultsScreen extends StatelessWidget {
  final String groupId;

  const PromptResultsScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final results = [
      {'id': '3', 'name': 'Sam', 'avatar': '🔥', 'votes': 3, 'percentage': 75},
      {'id': '1', 'name': 'You', 'avatar': '😎', 'votes': 1, 'percentage': 25},
      {'id': '2', 'name': 'Alex', 'avatar': '🤪', 'votes': 0, 'percentage': 0},
      {
        'id': '4',
        'name': 'Jordan',
        'avatar': '✨',
        'votes': 0,
        'percentage': 0
      },
    ];

    final winner = results[0];

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
              'Results',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'The squad has spoken',
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
          children: [
            // Question
            const Text('🧟', style: TextStyle(fontSize: 50)),
            const SizedBox(height: 12),
            const Text(
              'Who would survive a zombie apocalypse?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Winner Card
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFC0FF00), Color(0xFF00F5FF), Color(0xFFFF006E)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B),
                  borderRadius: BorderRadius.circular(21),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.emoji_events,
                        color: Color(0xFFC0FF00), size: 48),
                    const SizedBox(height: 16),
                    EmojiAvatar(emoji: winner['avatar'] as String, size: 'xl'),
                    const SizedBox(height: 16),
                    Text(
                      winner['name'] as String,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${winner['percentage']}%',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFC0FF00),
                      ),
                    ),
                    Text(
                      '${winner['votes']} votes',
                      style: const TextStyle(
                        color: Color(0xFFA1A1B5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Other Results
            ...results.skip(1).map((result) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2D2D44)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        EmojiAvatar(emoji: result['avatar'] as String, size: 'sm'),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            result['name'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '${result['percentage']}%',
                          style: const TextStyle(
                            color: Color(0xFFA1A1B5),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (result['percentage'] as int) / 100,
                        backgroundColor: const Color(0xFF2D2D44),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFFF006E)),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
