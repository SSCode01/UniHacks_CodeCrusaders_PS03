import 'package:flutter/material.dart';
import '../utils/colors.dart';

class FunkyButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final Widget? child;
  final String variant;
  final String size;
  final bool disabled;

  const FunkyButton({
    super.key,
    this.onPressed,
    this.text,
    this.child,
    this.variant = 'primary',
    this.size = 'md',
    this.disabled = false,
  });

  double _getHeight() {
    switch (size) {
      case 'sm':
        return 44;
      case 'lg':
        return 56;
      default:
        return 50;
    }
  }

  Gradient _getGradient() {
    switch (variant) {
      case 'secondary':
        return LinearGradient(
          colors: [AppColors.primaryBlue, AppColors.primaryPurple],
        );
      case 'accent':
        return const LinearGradient(
          colors: [Color(0xFFC0FF00), Color(0xFF00F5FF)],
        );
      default:
        return LinearGradient(
          colors: [AppColors.primaryPink, AppColors.primaryPurple],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _getHeight(),
      decoration: BoxDecoration(
        gradient: disabled ? null : _getGradient(),
        color: disabled ? const Color(0xFF2D2D44) : null,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: disabled ? null : onPressed,
        child: child ??
            Text(
              text ?? '',
              style: TextStyle(
                fontSize: size == 'lg' ? 16 : 14,
                fontWeight: FontWeight.w600,
                color: disabled
                    ? const Color(0xFFA1A1B5)
                    : const Color(0xFF0D1B2A),
              ),
            ),
      ),
    );
  }
}
