import 'package:flutter/material.dart';

class EmojiAvatar extends StatelessWidget {
  final String emoji;
  final String size;
  final EdgeInsets? margin;

  const EmojiAvatar({
    super.key,
    required this.emoji,
    this.size = 'md',
    this.margin,
  });

  double _getSize() {
    switch (size) {
      case 'sm':
        return 40;
      case 'md':
        return 56;
      case 'lg':
        return 72;
      case 'xl':
        return 96;
      default:
        return 56;
    }
  }

  double _getFontSize() {
    switch (size) {
      case 'sm':
        return 20;
      case 'md':
        return 28;
      case 'lg':
        return 36;
      case 'xl':
        return 48;
      default:
        return 28;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _getSize(),
      height: _getSize(),
      margin: margin,
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF2D2D44),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: _getFontSize()),
        ),
      ),
    );
  }
}
