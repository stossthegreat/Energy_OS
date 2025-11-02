import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../../providers/energy_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../../widgets/meal_story_card.dart';
import 'package:intl/intl.dart';

class TodayTab extends ConsumerStatefulWidget {
  const TodayTab({Key? key}) : super(key: key);

  @override
  ConsumerState<TodayTab> createState() => _TodayTabState();
}

class _TodayTabState extends ConsumerState<TodayTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final energyLevel = ref.watch(energyLevelProvider);
    final todayMeals = ref.watch(todayMealsProvider);
    final latestSleep = ref.watch(latestSleepProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rhythm Pulse Hero
          _buildRhythmPulse(energyLevel),

          const SizedBox(height: 32),

          // Morning Brief
          _buildMorningBrief(),

          const SizedBox(height: 24),

          // Daily Story Card
          _buildDailyStory(),

          const SizedBox(height: 24),

          // Sleep-Fuel Sync
          latestSleep.when(
            data: (sleep) => sleep != null ? _buildSleepSync(sleep) : const SizedBox(),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const SizedBox(),
          ),

          const SizedBox(height: 24),

          // Meal Timeline
          todayMeals.when(
            data: (meals) => _buildMealTimeline(meals),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const SizedBox(),
          ),

          const SizedBox(height: 24),

          // Ask Your Rhythm
          _buildAskRhythm(),
        ],
      ),
    );
  }

  Widget _buildRhythmPulse(double energyLevel) {
    return SizedBox(
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final pulse = 1 + math.sin(_pulseController.value * 2 * math.pi) * 0.15;
              return Transform.scale(
                scale: pulse,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.createGradient(AppConstants.todayGradient),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.hexToColor(AppConstants.todayGradient[0])
                            .withOpacity(0.4),
                        blurRadius: 60,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.4),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 40,
            child: Column(
              children: [
                const Text(
                  'Steady',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your rhythm is balanced',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMorningBrief() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.createGradient(AppConstants.todayGradient),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.hexToColor(AppConstants.todayGradient[0]).withOpacity(0.3),
            blurRadius: 30,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            // TODO: Play brief
          },
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Morning Rhythm Brief',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '"Good morning. Your rhythm is balanced — steady energy until 2pm."',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyStory() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
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
                'YOUR STORY TODAY',
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
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                height: 1.6,
              ),
              children: [
                const TextSpan(text: "You've started the morning with "),
                TextSpan(
                  text: 'steady fuel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = AppTheme.createGradient(AppConstants.todayGradient)
                          .createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                  ),
                ),
                const TextSpan(text: '. Blood sugar will stay even for '),
                const TextSpan(
                  text: '~3 hours',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: '. Perfect timing for that deep focus work you\'ve been planning.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepSync(sleep) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF818cf8).withOpacity(0.2),
            const Color(0xFF8b5cf6).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF818cf8).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF818cf8).withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.nightlight_round,
              color: Color(0xFF818cf8),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sleep-Fuel Sync',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF818cf8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You slept ${sleep.hours} hours last night — your body\'s in the optimal zone.',
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

  Widget _buildMealTimeline(List meals) {
    if (meals.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            'No meals logged today',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                gradient: AppTheme.createGradient(AppConstants.todayGradient),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'TODAY\'S FUEL STORY',
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
        ...meals.map((meal) => MealStoryCard(
          emoji: '🥗',
          title: meal.title ?? 'Meal',
          time: DateFormat('h:mm a').format(meal.timestamp),
          story: 'Balanced nutrition with ${meal.proteinG?.toStringAsFixed(0) ?? "?"g protein',
          gradientColors: AppConstants.todayGradient,
        )),
      ],
    );
  }

  Widget _buildAskRhythm() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.createGradient(AppConstants.todayGradient),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            // TODO: Open voice input
          },
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ask Your Rhythm',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Tap to speak with your OS',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

