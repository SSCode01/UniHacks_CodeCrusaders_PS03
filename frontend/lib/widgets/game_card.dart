import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final String title;
  final String description;
  final String emoji;
  final String gradient;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.title,
    required this.description,
    required this.emoji,
    required this.gradient,
    required this.onTap,
  });

  LinearGradient _getGradient() {
    switch (gradient) {
      case 'pink':
        return const LinearGradient(
          colors: [Color(0xFFFF006E), Color(0xFF8B5CF6)],
        );
      case 'blue':
        return const LinearGradient(
          colors: [Color(0xFF00F5FF), Color(0xFF0066FF)],
        );
      case 'purple':
        return const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
        );
      case 'orange':
        return const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
        );
      case 'lime':
        return const LinearGradient(
          colors: [Color(0xFFC0FF00), Color(0xFF00F5A0)],
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFFFF006E), Color(0xFF8B5CF6)],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          gradient: _getGradient(),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B263B),
            borderRadius: BorderRadius.circular(21),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xFFA1A1B5),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(emoji, style: const TextStyle(fontSize: 48)),
            ],
          ),
        ),
      ),
    );
  }
}
