import 'package:flutter/material.dart';
import '../widgets/funky_button.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({super.key});

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final TextEditingController _codeController = TextEditingController();

  void _joinGroup() {
    if (_codeController.text.length < 6) return;
    // Join group logic
    Navigator.pop(context);
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
              'Join Squad',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'Enter the invite code',
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ticket Emoji
            const Text('🎟️', style: TextStyle(fontSize: 80)),

            const SizedBox(height: 40),

            // Invite Code Input
            const Text(
              'Enter invite code',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1B263B),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF2D2D44),
                  width: 2,
                ),
              ),
              child: TextField(
                controller: _codeController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4,
                ),
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.characters,
                maxLength: 6,
                decoration: const InputDecoration(
                  hintText: "ABC123",
                  hintStyle: TextStyle(
                    color: Color(0xFFA1A1B5),
                    letterSpacing: 4,
                  ),
                  border: InputBorder.none,
                  counterText: '',
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),

            const SizedBox(height: 32),

            // Join Button
            SizedBox(
              width: double.infinity,
              child: FunkyButton(
                onPressed: _joinGroup,
                text: "Join the chaos 🎉",
                variant: 'secondary',
                size: 'lg',
                disabled: _codeController.text.length < 6,
              ),
            ),

            const SizedBox(height: 32),

            // Info Box
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
              child: const Text(
                "Ask your friend for the invite code. It's usually a 6-character code like ABC123",
                style: TextStyle(
                  color: Color(0xFFA1A1B5),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
