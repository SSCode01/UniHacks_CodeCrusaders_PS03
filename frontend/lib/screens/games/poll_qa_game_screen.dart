import 'package:flutter/material.dart';
import 'dart:math';
import '../../models/game_models.dart';
import '../../widgets/emoji_avatar.dart';
import '../../widgets/funky_button.dart';

class PollQAGameScreen extends StatefulWidget {
  final String groupId;

  const PollQAGameScreen({super.key, required this.groupId});

  @override
  State<PollQAGameScreen> createState() => _PollQAGameScreenState();
}

class _PollQAGameScreenState extends State<PollQAGameScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  
  String gamePhase = 'question'; // 'question', 'answering', 'voting', 'results'
  String? currentQuestion;
  List<Answer> answers = [];
  String? votedAnswerId;

  @override
  void initState() {
    super.initState();
  }

  void _submitQuestion() {
    if (_questionController.text.isEmpty) return;
    
    setState(() {
      currentQuestion = _questionController.text;
      gamePhase = 'answering';
      _generateMockAnswers();
    });
  }

  void _generateMockAnswers() {
    final random = Random();
    final sampleAnswers = [
      'Because it\'s the most logical choice!',
      'I think this makes the most sense',
      'This is definitely the right answer',
      'No doubt about it, this is it!',
      'Trust me on this one',
    ];

    answers.clear();
    
    // Add mock answers from other users
    for (int i = 1; i < GameData.mockMembers.length; i++) {
      final member = GameData.mockMembers[i];
      answers.add(Answer(
        userId: member.id,
        userName: member.name,
        userAvatar: member.avatar,
        answer: sampleAnswers[random.nextInt(sampleAnswers.length)],
      ));
    }
  }

  void _submitAnswer() {
    if (_answerController.text.isEmpty) return;
    
    setState(() {
      // Add user's answer
      final user = GameData.mockMembers[0];
      answers.insert(0, Answer(
        userId: user.id,
        userName: user.name,
        userAvatar: user.avatar,
        answer: _answerController.text,
      ));
      
      gamePhase = 'voting';
    });
  }

  void _vote(String answerId) {
    setState(() {
      votedAnswerId = answerId;
      
      // Add mock votes
      final random = Random();
      for (var answer in answers) {
        answer.votes = random.nextInt(4);
      }
      
      // Add user's vote
      final votedAnswer = answers.firstWhere((a) => a.userId == answerId);
      votedAnswer.votes++;
      
      gamePhase = 'results';
    });
  }

  void _playAgain() {
    setState(() {
      _questionController.clear();
      _answerController.clear();
      gamePhase = 'question';
      currentQuestion = null;
      answers.clear();
      votedAnswerId = null;
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
              'Poll-Based Q&A',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Answer & vote for the best',
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
      case 'question':
        return _buildQuestionPhase();
      case 'answering':
        return _buildAnsweringPhase();
      case 'voting':
        return _buildVotingPhase();
      case 'results':
        return _buildResultsPhase();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildQuestionPhase() {
    return Column(
      children: [
        const Text('🗳️', style: TextStyle(fontSize: 80)),
        const SizedBox(height: 24),
        const Text(
          'Ask a Question',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Your squad will answer, then vote for the best response',
          style: TextStyle(
            color: Color(0xFFA1A1B5),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1B263B),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF2D2D44)),
          ),
          child: TextField(
            controller: _questionController,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "What's the best pizza topping?",
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
            onPressed: _submitQuestion,
            text: "Ask Squad 🚀",
            size: 'lg',
            disabled: _questionController.text.isEmpty,
          ),
        ),
      ],
    );
  }

  Widget _buildAnsweringPhase() {
    return Column(
      children: [
        const Text('💭', style: TextStyle(fontSize: 60)),
        const SizedBox(height: 16),
        Text(
          currentQuestion!,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Your Answer',
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
            controller: _answerController,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Type your answer...",
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
            onPressed: _submitAnswer,
            text: "Submit Answer ✅",
            variant: 'secondary',
            size: 'lg',
            disabled: _answerController.text.isEmpty,
          ),
        ),
      ],
    );
  }

  Widget _buildVotingPhase() {
    return Column(
      children: [
        const Text('🗳️', style: TextStyle(fontSize: 60)),
        const SizedBox(height: 16),
        const Text(
          'Vote for the Best Answer',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          currentQuestion!,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFFA1A1B5),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ...answers.where((a) => a.userId != '1').map((answer) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => _vote(answer.userId),
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF2D2D44)),
                ),
                child: Row(
                  children: [
                    EmojiAvatar(emoji: answer.userAvatar, size: 'sm'),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            answer.userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            answer.answer,
                            style: const TextStyle(
                              color: Color(0xFFA1A1B5),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        color: Color(0xFFA1A1B5), size: 16),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildResultsPhase() {
    // Sort answers by votes
    final sortedAnswers = List<Answer>.from(answers)
      ..sort((a, b) => b.votes.compareTo(a.votes));
    final winner = sortedAnswers.first;

    return Column(
      children: [
        const Text('🏆', style: TextStyle(fontSize: 80)),
        const SizedBox(height: 24),
        const Text(
          'Winner!',
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
              colors: [Color(0xFFC0FF00), Color(0xFF00F5FF)],
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
                EmojiAvatar(emoji: winner.userAvatar, size: 'xl'),
                const SizedBox(height: 16),
                Text(
                  winner.userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '"${winner.answer}"',
                  style: const TextStyle(
                    color: Color(0xFFA1A1B5),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  '${winner.votes} ${winner.votes == 1 ? 'vote' : 'votes'}',
                  style: const TextStyle(
                    color: Color(0xFFC0FF00),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '+50 points',
                  style: TextStyle(
                    color: Color(0xFF00F5FF),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
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
            'All Answers',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...sortedAnswers.skip(1).map((answer) {
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
                  EmojiAvatar(emoji: answer.userAvatar, size: 'sm'),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          answer.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          answer.answer,
                          style: const TextStyle(
                            color: Color(0xFFA1A1B5),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${answer.votes} ${answer.votes == 1 ? 'vote' : 'votes'}',
                    style: const TextStyle(
                      color: Color(0xFFA1A1B5),
                      fontWeight: FontWeight.w700,
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
            variant: 'accent',
            size: 'lg',
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }
}
