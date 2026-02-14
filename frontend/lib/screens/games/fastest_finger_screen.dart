import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../models/game_models.dart';
import '../../widgets/emoji_avatar.dart';
import '../../widgets/funky_button.dart';

class FastestFingerScreen extends StatefulWidget {
  final String groupId;

  const FastestFingerScreen({super.key, required this.groupId});

  @override
  State<FastestFingerScreen> createState() => _FastestFingerScreenState();
}

class _FastestFingerScreenState extends State<FastestFingerScreen> {
  String gamePhase = 'intro'; // 'intro', 'playing', 'results'
  int currentQuestionIndex = 0;
  int timeLeft = 10;
  Timer? timer;
  int? selectedAnswer;
  bool answered = false;
  Map<String, int> scores = {};
  List<Question> gameQuestions = [];

  @override
  void initState() {
    super.initState();
    _initializeScores();
  }

  void _initializeScores() {
    for (var member in GameData.mockMembers) {
      scores[member.id] = 0;
    }
  }

  void _startGame() {
    setState(() {
      gamePhase = 'playing';
      currentQuestionIndex = 0;
      _initializeScores();
      
      // Select 5 random questions
      final random = Random();
      final allQuestions = List<Question>.from(GameData.triviaQuestions);
      allQuestions.shuffle(random);
      gameQuestions = allQuestions.take(5).toList();
      
      _startQuestion();
    });
  }

  void _startQuestion() {
    setState(() {
      timeLeft = 10;
      selectedAnswer = null;
      answered = false;
    });
    
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft > 0) {
        setState(() => timeLeft--);
      } else {
        _timeUp();
      }
    });
  }

  void _selectAnswer(int index) {
    if (answered) return;
    
    setState(() {
      selectedAnswer = index;
      answered = true;
    });
    
    timer?.cancel();
    
    final question = gameQuestions[currentQuestionIndex];
    final isCorrect = index == question.correctAnswer;
    
    if (isCorrect) {
      // Award points based on speed
      int points = 10;
      if (timeLeft > 5) {
        points += 5; // Speed bonus
      }
      scores['1'] = (scores['1'] ?? 0) + points;
    }
    
    // Generate mock scores for other users
    _generateMockScores();
    
    // Wait 2 seconds then move to next question
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (currentQuestionIndex < gameQuestions.length - 1) {
          setState(() {
            currentQuestionIndex++;
          });
          _startQuestion();
        } else {
          _endGame();
        }
      }
    });
  }

  void _timeUp() {
    if (answered) return;
    
    setState(() {
      answered = true;
    });
    
    timer?.cancel();
    
    // Generate mock scores for other users
    _generateMockScores();
    
    // Wait 2 seconds then move to next question
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (currentQuestionIndex < gameQuestions.length - 1) {
          setState(() {
            currentQuestionIndex++;
          });
          _startQuestion();
        } else {
          _endGame();
        }
      }
    });
  }

  void _generateMockScores() {
    final random = Random();
    for (int i = 1; i < GameData.mockMembers.length; i++) {
      final member = GameData.mockMembers[i];
      // Random chance to get points
      if (random.nextDouble() > 0.3) {
        scores[member.id] = (scores[member.id] ?? 0) + (random.nextBool() ? 15 : 10);
      }
    }
  }

  void _endGame() {
    timer?.cancel();
    setState(() {
      gamePhase = 'results';
    });
  }

  void _playAgain() {
    setState(() {
      gamePhase = 'intro';
      currentQuestionIndex = 0;
      _initializeScores();
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
          onPressed: () {
            timer?.cancel();
            Navigator.pop(context);
          },
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fastest Finger First',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Speed trivia challenge',
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
      case 'intro':
        return _buildIntroPhase();
      case 'playing':
        return _buildPlayingPhase();
      case 'results':
        return _buildResultsPhase();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildIntroPhase() {
    return Column(
      children: [
        const Text('⚡', style: TextStyle(fontSize: 80)),
        const SizedBox(height: 24),
        const Text(
          'Fastest Finger First',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Answer questions as fast as you can!',
          style: TextStyle(
            color: Color(0xFFA1A1B5),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B263B),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF2D2D44)),
          ),
          child: const Column(
            children: [
              Row(
                children: [
                  Text('⏱️', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '10 seconds per question',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text('✅', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Correct answer: +10 points',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text('⚡', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Speed bonus: +5 points (< 5 sec)',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text('🎯', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '5 questions total',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: FunkyButton(
            onPressed: _startGame,
            text: "Start Game 🚀",
            variant: 'accent',
            size: 'lg',
          ),
        ),
      ],
    );
  }

  Widget _buildPlayingPhase() {
    final question = gameQuestions[currentQuestionIndex];
    
    return Column(
      children: [
        // Progress
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}/${gameQuestions.length}',
              style: const TextStyle(
                color: Color(0xFFA1A1B5),
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Score: ${scores['1']}',
              style: const TextStyle(
                color: Color(0xFFC0FF00),
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Timer
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: timeLeft > 5
                  ? [const Color(0xFFC0FF00), const Color(0xFF00F5A0)]
                  : [const Color(0xFFFF006E), const Color(0xFF8B5CF6)],
            ),
          ),
          child: Center(
            child: Text(
              '$timeLeft',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Question
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B263B),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF2D2D44)),
          ),
          child: Text(
            question.question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Options
        ...question.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = selectedAnswer == index;
          final isCorrect = index == question.correctAnswer;
          final showResult = answered;
          
          Color? borderColor;
          if (showResult) {
            if (isCorrect) {
              borderColor = const Color(0xFFC0FF00);
            } else if (isSelected && !isCorrect) {
              borderColor = const Color(0xFFFF006E);
            }
          }
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: answered ? null : () => _selectAnswer(index),
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  gradient: borderColor != null
                      ? LinearGradient(colors: [borderColor, borderColor])
                      : null,
                  color: borderColor == null ? const Color(0xFF2D2D44) : null,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B263B),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2D44),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + index), // A, B, C, D
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (showResult && isCorrect)
                        const Icon(Icons.check_circle,
                            color: Color(0xFFC0FF00)),
                      if (showResult && isSelected && !isCorrect)
                        const Icon(Icons.cancel, color: Color(0xFFFF006E)),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildResultsPhase() {
    // Sort scores
    final sortedScores = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final winner = GameData.mockMembers.firstWhere((m) => m.id == sortedScores[0].key);
    
    return Column(
      children: [
        const Text('🏆', style: TextStyle(fontSize: 80)),
        const SizedBox(height: 24),
        const Text(
          'Game Over!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        
        // Winner
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFC0FF00), Color(0xFF00F5A0)],
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
                const Text('👑', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 16),
                EmojiAvatar(emoji: winner.avatar, size: 'xl'),
                const SizedBox(height: 12),
                Text(
                  winner.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${sortedScores[0].value} points',
                  style: const TextStyle(
                    color: Color(0xFFC0FF00),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Leaderboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        ...sortedScores.asMap().entries.map((entry) {
          final rank = entry.key;
          final scoreEntry = entry.value;
          final member = GameData.mockMembers.firstWhere((m) => m.id == scoreEntry.key);
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1B263B),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF2D2D44)),
              ),
              child: Row(
                children: [
                  Text(
                    ['🥇', '🥈', '🥉', '4️⃣'][rank],
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  EmojiAvatar(emoji: member.avatar, size: 'sm'),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      member.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '${scoreEntry.value} pts',
                    style: const TextStyle(
                      color: Color(0xFFC0FF00),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        
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
    timer?.cancel();
    super.dispose();
  }
}
