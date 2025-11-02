import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
import '../../widgets/coach_ask_widget.dart';
import '../../widgets/mode_card.dart';

class TrainTab extends ConsumerStatefulWidget {
  const TrainTab({Key? key}) : super(key: key);

  @override
  ConsumerState<TrainTab> createState() => _TrainTabState();
}

class _TrainTabState extends ConsumerState<TrainTab> {
  String _selectedMode = 'Performance';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coach Ask
          const CoachAskWidget(
            tabType: 'train',
            placeholder: 'Give me a 30-min upper-body dumbbell workout',
            gradientColors: AppConstants.trainGradient,
          ),

          const SizedBox(height: 24),

          // Mode Grid
          _buildModeGrid(),

          const SizedBox(height: 24),

          // Recovery Intelligence
          _buildRecoveryStatus(),

          const SizedBox(height: 24),

          // Today's Session
          _buildTodaySession(),

          const SizedBox(height: 24),

          // Performance Arc (7-day)
          _buildPerformanceArc(),

          const SizedBox(height: 24),

          // Post-Workout Fuel Sync
          _buildFuelSync(),
        ],
      ),
    );
  }

  Widget _buildModeGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                gradient: AppTheme.createGradient(AppConstants.trainGradient),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'TUNE YOUR MODE',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.4),
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            ModeCard(
              mode: 'Performance',
              emoji: '🔥',
              description: 'Push limits, chase PRs',
              isActive: _selectedMode == 'Performance',
              gradientColors: AppConstants.trainGradient,
              onTap: () => setState(() => _selectedMode = 'Performance'),
            ),
            ModeCard(
              mode: 'Recovery',
              emoji: '🌙',
              description: 'Restore & rebuild',
              isActive: _selectedMode == 'Recovery',
              onTap: () => setState(() => _selectedMode = 'Recovery'),
            ),
            ModeCard(
              mode: 'Aesthetic',
              emoji: '💎',
              description: 'Sculpt & refine',
              isActive: _selectedMode == 'Aesthetic',
              onTap: () => setState(() => _selectedMode = 'Aesthetic'),
            ),
            ModeCard(
              mode: 'Longevity',
              emoji: '🌱',
              description: 'Sustain & optimize',
              isActive: _selectedMode == 'Longevity',
              onTap: () => setState(() => _selectedMode = 'Longevity'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecoveryStatus() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF34d399).withOpacity(0.2),
            const Color(0xFF14b8a6).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF34d399).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    'RECOVERY STATUS',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.4),
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF34d399).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF34d399).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF34d399),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '92% Ready',
                      style: TextStyle(
                        color: Color(0xFF34d399),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Your body recovered 8% faster than usual. That salmon bowl yesterday accelerated repair. Ready to push hard today.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySession() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFa78bfa).withOpacity(0.2),
            const Color(0xFFec4899).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFa78bfa).withOpacity(0.3),
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
                'TODAY\'S SESSION',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.4),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Upper Body Power',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re primed to push hard today — let\'s chase some PRs. Your sleep + fuel are aligned.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.6),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.createGradient(AppConstants.trainGradient),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        // TODO: Start session
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Start Session',
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
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.trending_up),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  padding: const EdgeInsets.all(20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceArc() {
    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    final values = [65, 80, 90, 75, 85, 95, 90];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
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
                '7-DAY ENERGY ARC',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.4),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(days.length, (index) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          height: values[index] * 1.6,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            gradient: AppTheme.createGradient(AppConstants.trainGradient),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          days[index],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuelSync() {
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF06b6d4).withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bolt,
              color: Color(0xFF06b6d4),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Auto-Adjusted Recovery Fuel',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF06b6d4),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Based on today\'s session intensity, post-workout protein bumped to 45g. Your recovery bowl is ready in Fuel tab.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
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
}

