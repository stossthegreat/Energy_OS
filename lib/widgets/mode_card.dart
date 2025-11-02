import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ModeCard extends StatelessWidget {
  final String mode;
  final String emoji;
  final String description;
  final bool isActive;
  final List<String>? gradientColors;
  final VoidCallback onTap;

  const ModeCard({
    Key? key,
    required this.mode,
    required this.emoji,
    required this.description,
    required this.isActive,
    this.gradientColors,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isActive 
              ? Colors.white.withOpacity(0.1)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive 
                ? Colors.white.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
            width: isActive ? 2 : 1,
          ),
          gradient: isActive && gradientColors != null
              ? AppTheme.createGradient(gradientColors!).scale(0.1)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 12),
            Text(
              mode,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

extension _GradientScale on Gradient {
  Gradient scale(double opacity) {
    if (this is LinearGradient) {
      final linear = this as LinearGradient;
      return LinearGradient(
        colors: linear.colors.map((c) => c.withOpacity(opacity)).toList(),
        begin: linear.begin,
        end: linear.end,
      );
    }
    return this;
  }
}

