import 'package:flutter/material.dart';
import 'dart:math';
import '../../models/game_models.dart';
import '../../widgets/emoji_avatar.dart';
import '../../widgets/funky_button.dart';

class TruthDareGameScreen extends StatefulWidget {
  final String groupId;

  const TruthDareGameScreen({super.key, required this.groupId});

  @override
  State<TruthDareGameScreen> createState() => _TruthDareGameScreenState();
}

class _TruthDareGameScreenState extends State<TruthDareGameScreen> {
  String gamePhase = 'voting'; // 'voting', 'selection', 'response', 'results'
  GameMember? selectedUser;
  String? selectedChoice; // 'truth' or 'dare'
  String? currentChallenge;
  final TextEditingController _responseController = TextEditingController();
  Map<String, int> votes = {};

  void _generateMockVotes() {
    votes.clear();
    final random = Random();
    
    for (var member in GameData.mockMembers) {
      votes[member.id] = random.nextInt(3);
    }
    
    // Add one more vote to make it interesting
    final randomMember = GameData.mockMembers[random.nextInt(GameData.mockMembers.length)];
    votes[randomMember.id] = (votes[randomMember.id] ?? 0) + 1;
  }

  void _submitVote(String userId) {
    setState(() {
      _generateMockVotes();
      votes[userId] = (votes[userId] ?? 0) + 1;
      
      // Find user with most votes
      String maxUserId = votes.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      selectedUser = GameData.mockMembers.firstWhere((m) => m.id == maxUserId);
      
      gamePhase = 'selection';
    });
  }

  void _selectChoice(String choice) {
    final random = Random();
    setState(() {
      selectedChoice = choice;
      
      if (choice == 'truth') {
        currentChallenge = GameData.truths[random.nextInt(GameData.truths.length)];
      } else {
        currentChallenge = GameData.dares[random.nextInt(GameData.dares.length)];
      }
      
      gamePhase = 'response';
    });
  }

  void _submitResponse() {
    if (_responseController.text.isEmpty) return;
    
    setState(() {
      gamePhase = 'results';
    });
  }

  void _playAgain() {
    setState(() {
      gamePhase = 'voting';
      selectedUser = null;
      selectedChoice = null;
      currentChallenge = null;
      _responseController.clear();
      votes.clear();
    });
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
              'Truth or Dare',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Anonymous selection',
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
        child: _buildPhaseContent(),
      ),
    );
  }

  Widget _buildPhaseContent() {
    switch (gamePhase) {
      case 'voting':
        return _buildVotingPhase();
      case 'selection':
        return _buildSelectionPhase();
      case 'response':
        return _buildResponsePhase();
      case 'results':
        return _buildResultsPhase();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildVotingPhase() {
    return Column(
      children: [
        const Text('🎭', style: TextStyle(fontSize: 80)),
        const SizedBox(height: 24),
        const Text(
          'Who Should Go?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Vote anonymously for who should do truth or dare',
          style: TextStyle(
            color: Color(0xFFA1A1B5),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ...GameData.mockMembers.map((member) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => _submitVote(member.id),
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF2D2D44)),
                ),
                child: Row(
                  children: [
                    EmojiAvatar(emoji: member.avatar, size: 'md'),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        member.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(Icons.how_to_vote,
                        color: Color(0xFF8B5CF6), size: 24),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSelectionPhase() {
    return Column(
      children: [
        const Text('🎯', style: TextStyle(fontSize: 80)),
        const SizedBox(height: 24),
        const Text(
          'Selected!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
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
                EmojiAvatar(emoji: selectedUser!.avatar, size: 'xl'),
                const SizedBox(height: 16),
                Text(
                  selectedUser!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${votes[selectedUser!.id]} ${votes[selectedUser!.id] == 1 ? 'vote' : 'votes'}',
                  style: const TextStyle(
                    color: Color(0xFFA1A1B5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Choose wisely...',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectChoice('truth'),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00F5FF), Color(0xFF0066FF)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B263B),
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: const Column(
                      children: [
                        Text('💬', style: TextStyle(fontSize: 48)),
                        SizedBox(height: 12),
                        Text(
                          'TRUTH',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _selectChoice('dare'),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF006E), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B263B),
                      borderRadius: BorderRadius.circular(21),
                    ),
                    child: const Column(
                      children: [
                        Text('🔥', style: TextStyle(fontSize: 48)),
                        SizedBox(height: 12),
                        Text(
                          'DARE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResponsePhase() {
    return Column(
      children: [
        Text(selectedChoice == 'truth' ? '💬' : '🔥',
            style: const TextStyle(fontSize: 80)),
        const SizedBox(height: 24),
        Text(
          selectedChoice == 'truth' ? 'Truth Time' : 'Dare Challenge',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B263B),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF2D2D44)),
          ),
          child: Text(
            currentChallenge!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Your Response',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1B263B),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF2D2D44)),
          ),
          child: TextField(
            controller: _responseController,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Type your response...",
              hintStyle: TextStyle(color: Color(0xFFA1A1B5)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FunkyButton(
            onPressed: _submitResponse,
            text: "Submit ✅",
            variant: 'accent',
            size: 'lg',
            disabled: _responseController.text.isEmpty,
          ),
        ),
      ],
    );
  }

  Widget _buildResultsPhase() {
    return Column(
      children: [
        const Text('✨', style: TextStyle(fontSize: 80)),
        const SizedBox(height: 24),
        const Text(
          'Challenge Complete!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B263B),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF2D2D44)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  EmojiAvatar(emoji: selectedUser!.avatar, size: 'md'),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedUser!.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: selectedChoice == 'truth'
                          ? const Color(0xFF00F5FF)
                          : const Color(0xFFFF006E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      selectedChoice!.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFF2D2D44)),
              const SizedBox(height: 16),
              Text(
                currentChallenge!,
                style: const TextStyle(
                  color: Color(0xFFA1A1B5),
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFF2D2D44)),
              const SizedBox(height: 16),
              Text(
                _responseController.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
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
    );
  }

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }
}
