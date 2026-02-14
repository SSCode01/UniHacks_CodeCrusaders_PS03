import 'package:flutter/material.dart';
import '../utils/colors.dart';

class GradientCard extends StatelessWidget {
  final Widget child;
  final String gradient;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  const GradientCard({
    super.key,
    required this.child,
    required this.gradient,
    this.onTap,
    this.padding,
  });

  LinearGradient _getGradient() {
    switch (gradient) {
      case 'pink':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryPink, AppColors.primaryPurple],
        );
      case 'blue':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlue, AppColors.primaryPurple],
        );
      case 'lime':
      case 'accent':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFC0FF00), Color(0xFF00FF88)],
        );
      case 'purple':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryPurple, AppColors.primaryPink],
        );
      default:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryPink, AppColors.primaryPurple],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: _getGradient(),
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      ),
    );
  }
}
