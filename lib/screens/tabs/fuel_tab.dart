import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../../widgets/coach_ask_widget.dart';
import '../../widgets/feeling_card.dart';

class FuelTab extends ConsumerWidget {
  const FuelTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coach Ask
          const CoachAskWidget(
            tabType: 'fuel',
            placeholder: 'I have chicken, rice, and spinach—what can I cook?',
            gradientColors: AppConstants.fuelGradient,
          ),

          const SizedBox(height: 24),

          // Photo Scanner Hero
          _buildMealScanner(context),

          const SizedBox(height: 24),

          // AI Insight
          _buildAIInsight(),

          const SizedBox(height: 24),

          // Feeling Cards
          _buildFeelingCards(),

          const SizedBox(height: 24),

          // Chef's Pick
          _buildChefsPick(context),
        ],
      ),
    );
  }

  Widget _buildMealScanner(BuildContext context) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        gradient: AppTheme.createGradient(AppConstants.fuelGradient),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.hexToColor(AppConstants.fuelGradient[0]).withOpacity(0.3),
            blurRadius: 30,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            // TODO: Open meal scanner
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.black.withOpacity(0.2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Scan Your Meal',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Instant nutrition + feeling prediction',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAIInsight() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF8b5cf6).withOpacity(0.2),
            const Color(0xFF9333ea).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF8b5cf6).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF8b5cf6).withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Color(0xFF8b5cf6),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pattern Discovered',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8b5cf6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '90% of your foggy afternoons follow low-protein lunches. Adding 20g protein keeps you sharp until dinner.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeelingCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                gradient: AppTheme.createGradient(AppConstants.fuelGradient),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'RECENT MEALS & FEELINGS',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.4),
                letterSpacing: 1.5,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const FeelingCard(
          meal: 'Salmon Bowl',
          feeling: 'Energized for 4 hours',
          emoji: '⚡',
          color: Color(0xFF34d399),
        ),
        const FeelingCard(
          meal: 'Pizza Margherita',
          feeling: 'Sluggish after 90min',
          emoji: '😴',
          color: Color(0xFFf59e0b),
        ),
        const FeelingCard(
          meal: 'Chicken Caesar',
          feeling: 'Light & focused',
          emoji: '🎯',
          color: Color(0xFF60a5fa),
        ),
      ],
    );
  }

  Widget _buildChefsPick(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: AppTheme.createGradient(AppConstants.fuelGradient),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: const Center(
                child: Text(
                  '🍜',
                  style: TextStyle(fontSize: 80),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.white.withOpacity(0.4),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'CHEF\'S PICK TONIGHT',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.4),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Garlic Shrimp Pasta',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Matches your rhythm • 25min cook time',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.createGradient(AppConstants.fuelGradient),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        // TODO: Start cooking
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.mic, color: Colors.white),
                            SizedBox(width: 12),
                            Text(
                              'Start Cooking with Voice',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

