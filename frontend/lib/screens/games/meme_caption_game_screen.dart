import 'package:flutter/material.dart';
import 'dart:math';
import '../../models/game_models.dart';
import '../../widgets/emoji_avatar.dart';
import '../../widgets/funky_button.dart';

class MemeCaptionGameScreen extends StatefulWidget {
  final String groupId;

  const MemeCaptionGameScreen({super.key, required this.groupId});

  @override
  State<MemeCaptionGameScreen> createState() => _MemeCaptionGameScreenState();
}

class _MemeCaptionGameScreenState extends State<MemeCaptionGameScreen> {
  String gamePhase = 'selection'; // 'selection', 'captioning', 'voting', 'results'
  MemeTemplate? selectedMeme;
  final TextEditingController _captionController = TextEditingController();
  List<Caption> captions = [];
  String? votedCaptionId;

  void _selectMeme(MemeTemplate meme) {
    setState(() {
      selectedMeme = meme;
      gamePhase = 'captioning';
      _generateMockCaptions();
    });
  }

  void _generateMockCaptions() {
    final random = Random();
    final sampleCaptions = [
      'When you realize it\'s Monday tomorrow',
      'Me pretending to understand the assignment',
      'That moment when you see your bank balance',
      'Trying to act normal in public',
      'When someone asks if I\'m okay',
    ];

    captions.clear();
    
    // Add mock captions from other users
    for (int i = 1; i < GameData.mockMembers.length; i++) {
      final member = GameData.mockMembers[i];
      captions.add(Caption(
        userId: member.id,
        userName: member.name,
        userAvatar: member.avatar,
        caption: sampleCaptions[random.nextInt(sampleCaptions.length)],
      ));
    }
  }

  void _submitCaption() {
    if (_captionController.text.isEmpty) return;
    
    setState(() {
      // Add user's caption
      final user = GameData.mockMembers[0];
      captions.insert(0, Caption(
        userId: user.id,
        userName: user.name,
        userAvatar: user.avatar,
        caption: _captionController.text,
      ));
      
      gamePhase = 'voting';
    });
  }

  void _vote(String captionId) {
    setState(() {
      votedCaptionId = captionId;
      
      // Add mock votes
      final random = Random();
      for (var caption in captions) {
        caption.votes = random.nextInt(4);
      }
      
      // Add user's vote
      final votedCaption = captions.firstWhere((c) => c.userId == captionId);
      votedCaption.votes++;
      
      gamePhase = 'results';
    });
  }

  void _playAgain() {
    setState(() {
      gamePhase = 'selection';
      selectedMeme = null;
      _captionController.clear();
      captions.clear();
      votedCaptionId = null;
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
              'Meme Caption Challenge',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Caption & win points',
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
      case 'selection':
        return _buildSelectionPhase();
      case 'captioning':
        return _buildCaptioningPhase();
      case 'voting':
        return _buildVotingPhase();
      case 'results':
        return _buildResultsPhase();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSelectionPhase() {
    return Column(
      children: [
        const Text('😂', style: TextStyle(fontSize: 80)),
        const SizedBox(height: 24),
        const Text(
          'Choose a Meme',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Select a meme template to caption',
          style: TextStyle(
            color: Color(0xFFA1A1B5),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: GameData.memeTemplates.length,
          itemBuilder: (context, index) {
            final meme = GameData.memeTemplates[index];
            return InkWell(
              onTap: () => _selectMeme(meme),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF2D2D44)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(meme.emoji, style: const TextStyle(fontSize: 48)),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        meme.description,
                        style: const TextStyle(
                          color: Color(0xFFA1A1B5),
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCaptioningPhase() {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(selectedMeme!.emoji, style: const TextStyle(fontSize: 120)),
        ),
        const SizedBox(height: 24),
        const Text(
          'Caption This!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Your Caption',
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
            controller: _captionController,
            style: const TextStyle(color: Colors.white),
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: "When you realize it's Monday...",
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
            onPressed: _submitCaption,
            text: "Submit Caption 📝",
            variant: 'accent',
            size: 'lg',
            disabled: _captionController.text.isEmpty,
          ),
        ),
      ],
    );
  }

  Widget _buildVotingPhase() {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(selectedMeme!.emoji, style: const TextStyle(fontSize: 80)),
        ),
        const SizedBox(height: 16),
        const Text(
          'Vote for the Funniest',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ...captions.where((c) => c.userId != '1').map((caption) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => _vote(caption.userId),
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B263B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF2D2D44)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        EmojiAvatar(emoji: caption.userAvatar, size: 'sm'),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            caption.userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '"${caption.caption}"',
                      style: const TextStyle(
                        color: Color(0xFFA1A1B5),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
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
    // Sort captions by votes
    final sortedCaptions = List<Caption>.from(captions)
      ..sort((a, b) => b.votes.compareTo(a.votes));
    final winner = sortedCaptions.first;

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
              colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
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
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(selectedMeme!.emoji, style: const TextStyle(fontSize: 80)),
                ),
                const SizedBox(height: 16),
                EmojiAvatar(emoji: winner.userAvatar, size: 'lg'),
                const SizedBox(height: 12),
                Text(
                  winner.userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '"${winner.caption}"',
                  style: const TextStyle(
                    color: Color(0xFFA1A1B5),
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  '${winner.votes} ${winner.votes == 1 ? 'vote' : 'votes'}',
                  style: const TextStyle(
                    color: Color(0xFFF7931E),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '+100 points',
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
            'All Captions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...sortedCaptions.skip(1).map((caption) {
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
                  EmojiAvatar(emoji: caption.userAvatar, size: 'sm'),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          caption.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '"${caption.caption}"',
                          style: const TextStyle(
                            color: Color(0xFFA1A1B5),
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${caption.votes}',
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
            variant: 'secondary',
            size: 'lg',
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }
}
