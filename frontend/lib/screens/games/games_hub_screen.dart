import 'package:flutter/material.dart';
import '../../widgets/game_card.dart';
import 'poll_qa_game_screen.dart';
import 'would_you_rather_screen.dart';
import 'truth_dare_game_screen.dart';
import 'meme_caption_game_screen.dart';
import 'fastest_finger_screen.dart';

class GamesHubScreen extends StatelessWidget {
  final String groupId;

  const GamesHubScreen({super.key, required this.groupId});

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
              'Mini Games Hub',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Play & compete with your squad',
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
            // Poll-Based Q&A
            GameCard(
              title: '🗳️ Poll-Based Q&A',
              description: 'Answer questions & vote for the best',
              emoji: '🗳️',
              gradient: 'pink',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PollQAGameScreen(groupId: groupId),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Would You Rather
            GameCard(
              title: '🤷 Would You Rather?',
              description: 'Make tough choices with your squad',
              emoji: '🤷',
              gradient: 'blue',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WouldYouRatherScreen(groupId: groupId),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Truth or Dare
            GameCard(
              title: '🎭 Truth or Dare',
              description: 'Anonymous selection & challenges',
              emoji: '🎭',
              gradient: 'purple',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TruthDareGameScreen(groupId: groupId),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Meme Caption Challenge
            GameCard(
              title: '😂 Meme Caption Challenge',
              description: 'Caption memes & win points',
              emoji: '😂',
              gradient: 'orange',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MemeCaptionGameScreen(groupId: groupId),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Fastest Finger First
            GameCard(
              title: '⚡ Fastest Finger First',
              description: 'Speed trivia challenge',
              emoji: '⚡',
              gradient: 'lime',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FastestFingerScreen(groupId: groupId),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1B263B),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF2D2D44)),
              ),
              child: const Row(
                children: [
                  Text('🎮', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'All games are playable with mock squad members. Points are tracked locally!',
                      style: TextStyle(
                        color: Color(0xFFA1A1B5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
