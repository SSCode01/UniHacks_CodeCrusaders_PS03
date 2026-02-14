import 'package:flutter/material.dart';
import 'dart:math';
import '../../models/game_models.dart';
import '../../widgets/emoji_avatar.dart';
import '../../widgets/funky_button.dart';

class WouldYouRatherScreen extends StatefulWidget {
  final String groupId;

  const WouldYouRatherScreen({super.key, required this.groupId});

  @override
  State<WouldYouRatherScreen> createState() => _WouldYouRatherScreenState();
}

class _WouldYouRatherScreenState extends State<WouldYouRatherScreen> {
  late WouldYouRatherQuestion currentQuestion;
  String? selectedOption; // 'A' or 'B'
  bool showResults = false;
  Map<String, String> userChoices = {}; // userId -> 'A' or 'B'

  @override
  void initState() {
    super.initState();
    _loadNewQuestion();
  }

  void _loadNewQuestion() {
    final random = Random();
    currentQuestion = GameData.wouldYouRatherQuestions[
        random.nextInt(GameData.wouldYouRatherQuestions.length)];
    
    // Generate random choices for other users
    _generateMockChoices();
  }

  void _generateMockChoices() {
    final random = Random();
    userChoices.clear();
    
    for (var member in GameData.mockMembers) {
      if (member.id != '1') {
        // Random choice for other users
        userChoices[member.id] = random.nextBool() ? 'A' : 'B';
      }
    }
  }

  void _selectOption(String option) {
    setState(() {
      selectedOption = option;
      userChoices['1'] = option; // Current user's choice
      showResults = true;
    });
  }

  void _playAgain() {
    setState(() {
      selectedOption = null;
      showResults = false;
      _loadNewQuestion();
    });
  }

  int _getOptionCount(String option) {
    return userChoices.values.where((choice) => choice == option).length;
  }

  double _getOptionPercentage(String option) {
    if (userChoices.isEmpty) return 0;
    return (_getOptionCount(option) / userChoices.length) * 100;
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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Would You Rather?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Make your choice',
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
            // Question emoji
            Text(currentQuestion.emoji, style: const TextStyle(fontSize: 80)),
            const SizedBox(height: 24),

            // Question
            Text(
              currentQuestion.question,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Option A
            _buildOptionCard(
              'A',
              currentQuestion.optionA,
              const Color(0xFFFF006E),
            ),

            const SizedBox(height: 16),

            // VS Divider
            const Row(
              children: [
                Expanded(child: Divider(color: Color(0xFF2D2D44))),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      color: Color(0xFFA1A1B5),
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Color(0xFF2D2D44))),
              ],
            ),

            const SizedBox(height: 16),

            // Option B
            _buildOptionCard(
              'B',
              currentQuestion.optionB,
              const Color(0xFF00F5FF),
            ),

            if (showResults) ...[
              const SizedBox(height: 32),

              // Results Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF2D2D44)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Squad Results',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Show who chose what
                    ...GameData.mockMembers.map((member) {
                      final choice = userChoices[member.id];
                      if (choice == null) return const SizedBox.shrink();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            EmojiAvatar(emoji: member.avatar, size: 'sm'),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                member.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: choice == 'A'
                                    ? const Color(0xFFFF006E)
                                    : const Color(0xFF00F5FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Option $choice',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Play Again Button
              SizedBox(
                width: double.infinity,
                child: FunkyButton(
                  onPressed: _playAgain,
                  text: "Play Again 🎮",
                  variant: 'secondary',
                  size: 'lg',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(String option, String text, Color color) {
    final isSelected = selectedOption == option;
    final percentage = showResults ? _getOptionPercentage(option) : 0.0;

    return InkWell(
      onTap: showResults ? null : () => _selectOption(option),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [color, color.withOpacity(0.6)])
              : null,
          color: isSelected ? null : const Color(0xFF2D2D44),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B263B),
            borderRadius: BorderRadius.circular(21),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              if (showResults) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: const Color(0xFF2D2D44),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${percentage.toStringAsFixed(0)}% (${_getOptionCount(option)} ${_getOptionCount(option) == 1 ? 'person' : 'people'})',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
