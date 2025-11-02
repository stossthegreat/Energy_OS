import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/theme.dart';

class AnimatedBackground extends StatefulWidget {
  final List<String> gradientColors;
  final Widget child;

  const AnimatedBackground({
    Key? key,
    required this.gradientColors,
    required this.child,
  }) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Black background
        Container(color: Colors.black),
        
        // Animated orbs
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final pulse = math.sin(_controller.value * 2 * math.pi) * 0.15 + 1;
            final opacity = math.sin(_controller.value * math.pi) * 0.3 + 0.6;
            
            return Stack(
              children: [
                // Orb 1 - Top Left
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.25,
                  left: MediaQuery.of(context).size.width * 0.25,
                  child: Transform.scale(
                    scale: pulse,
                    child: Transform.translate(
                      offset: Offset(
                        math.sin(_controller.value * 2 * math.pi) * 20,
                        math.cos(_controller.value * 2 * math.pi) * 20,
                      ),
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppTheme.createGradient(widget.gradientColors),
                        ),
                      ).applyBlur(opacity * 0.15),
                    ),
                  ),
                ),
                
                // Orb 2 - Bottom Right
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.25,
                  right: MediaQuery.of(context).size.width * 0.25,
                  child: Transform.scale(
                    scale: pulse * 0.9,
                    child: Transform.translate(
                      offset: Offset(
                        math.cos(_controller.value * 2.5 * math.pi) * 30,
                        math.sin(_controller.value * 2.5 * math.pi) * 30,
                      ),
                      child: Container(
                        width: 400,
                        height: 400,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppTheme.createGradient(widget.gradientColors),
                        ),
                      ).applyBlur(opacity * 0.12),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        
        // Content
        widget.child,
      ],
    );
  }
}

extension _BlurExtension on Widget {
  Widget applyBlur(double opacity) {
    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 100,
              spreadRadius: 50,
            ),
          ],
        ),
        child: this,
      ),
    );
  }
}

