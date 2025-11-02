import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../../widgets/progress_stat.dart';

class EvolveTab extends ConsumerWidget {
  const EvolveTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Biology Model
          _buildBiologyModel(),

          const SizedBox(height: 24),

          // AI Pattern Discovery
          _buildPatternDiscovery(),

          const SizedBox(height: 24),

          // Trigger Map
          _buildTriggerMap(),

          const SizedBox(height: 24),

          // Predictive Insights
          _buildPredictiveInsights(),

          const SizedBox(height: 24),

          // Voice Reflection
          _buildVoiceReflection(),
        ],
      ),
    );
  }

  Widget _buildBiologyModel() {
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
                Icons.psychology,
                color: Colors.white.withOpacity(0.4),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'YOUR BIOLOGY MODEL',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.4),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ProgressStat(
            label: 'Food-Feeling Patterns',
            value: 18,
            maxValue: 20,
            gradientColors: ['#34d399', '#14b8a6'],
          ),
          const SizedBox(height: 20),
          const ProgressStat(
            label: 'Rhythm Stability',
            value: 85,
            maxValue: 100,
            gradientColors: ['#8b5cf6', '#9333ea'],
          ),
          const SizedBox(height: 20),
          const ProgressStat(
            label: 'Body Intuition Score',
            value: 92,
            maxValue: 100,
            gradientColors: ['#f59e0b', '#f97316'],
          ),
          const SizedBox(height: 16),
          Text(
            'You\'re becoming intuitive — app usage down 15% while results improve.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.4),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternDiscovery() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF818cf8).withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFF818cf8),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'This Week\'s Breakthrough',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF818cf8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.6,
              ),
              children: [
                const TextSpan(
                  text: '90%',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: ' of your foggy afternoons follow low-protein breakfasts. When you hit ',
                ),
                const TextSpan(
                  text: '25g+ protein',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: ' by 9am, you stay sharp until dinner.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '→ Auto-adjusted tomorrow\'s breakfast recommendation',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF34d399),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerMap() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFf43f5e).withOpacity(0.2),
            const Color(0xFFec4899).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFf43f5e).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFf43f5e).withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFFf43f5e),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Trigger Insight',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFf43f5e),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.6,
              ),
              children: [
                TextSpan(
                  text: 'You crave sugar after stressful work calls — detected ',
                ),
                TextSpan(
                  text: '7 times',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: ' this month. It\'s your body seeking quick comfort and dopamine.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Try instead: 5min walk + sparkling water with lemon. Success rate: 73%',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF34d399),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictiveInsights() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF06b6d4).withOpacity(0.2),
            const Color(0xFF14b8a6).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF06b6d4).withOpacity(0.3),
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
                'FORECASTS',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.4),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildForecastRow('Energy Peak', 'Tomorrow 1:30pm'),
          _buildForecastRow('Skin Clarity Peak', 'Thursday'),
          _buildForecastRow('Recovery Window', '48 hours'),
        ],
      ),
    );
  }

  Widget _buildForecastRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceReflection() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.createGradient(AppConstants.evolveGradient),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            // TODO: Play monthly reflection
          },
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Monthly Reflection',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '2min voice summary of your evolution • Ready to play',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

