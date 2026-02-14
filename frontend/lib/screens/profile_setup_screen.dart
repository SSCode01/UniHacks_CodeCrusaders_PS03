import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/emoji_avatar.dart';
import '../widgets/funky_button.dart';
import 'daily_mood_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String selectedEmoji = '😎';

  final List<String> emojis = [
    '😎',
    '🤪',
    '🔥',
    '✨',
    '🎭',
    '🦄',
    '👾',
    '🌈',
    '💀',
    '🍕',
    '🎮',
    '🎨'
  ];

  void _completeSetup() {
    if (_nameController.text.isEmpty) return;

    // Save user data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DailyMoodScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Header
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFC0FF00), Color(0xFF00F5FF)],
                ).createShader(bounds),
                child: const Text(
                  "Make it yours",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Pick a vibe, drop some info",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFA1A1B5),
                ),
              ),

              const SizedBox(height: 40),

              // Avatar Selection
              const Text(
                "Pick your avatar",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              EmojiAvatar(emoji: selectedEmoji, size: 'xl'),

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

              // Name Input
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "What should we call you?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
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
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Your display name",
                    hintStyle: TextStyle(color: Color(0xFFA1A1B5)),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Bio Input
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "A little about you (optional)",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
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
                  controller: _bioController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "Professional meme consumer, chaos coordinator...",
                    hintStyle: TextStyle(color: Color(0xFFA1A1B5)),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Complete Button
              SizedBox(
                width: double.infinity,
                child: FunkyButton(
                  onPressed: _completeSetup,
                  text: "Let's cause problems 😈",
                  variant: 'accent',
                  size: 'lg',
                  disabled: _nameController.text.isEmpty,
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
