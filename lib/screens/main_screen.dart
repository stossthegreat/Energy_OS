import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/animated_background.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/constants.dart';
import 'tabs/today_tab.dart';
import 'tabs/fuel_tab.dart';
import 'tabs/train_tab.dart';
import 'tabs/mind_tab.dart';
import 'tabs/evolve_tab.dart';
import 'tabs/tribe_tab.dart';
import 'settings_screen.dart';
import 'inbox_screen.dart';

final _currentTabProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTabIndex = ref.watch(_currentTabProvider);

    final tabs = [
      {'icon': Icons.wb_sunny, 'label': 'Today', 'gradient': AppConstants.todayGradient},
      {'icon': Icons.restaurant, 'label': 'Fuel', 'gradient': AppConstants.fuelGradient},
      {'icon': Icons.fitness_center, 'label': 'Train', 'gradient': AppConstants.trainGradient},
      {'icon': Icons.psychology, 'label': 'Mind', 'gradient': AppConstants.mindGradient},
      {'icon': Icons.auto_awesome, 'label': 'Evolve', 'gradient': AppConstants.evolveGradient},
      {'icon': Icons.groups, 'label': 'Tribe', 'gradient': AppConstants.tribeGradient},
    ];

    final currentGradient = tabs[currentTabIndex]['gradient'] as List<String>;

    return AnimatedBackground(
      gradientColors: currentGradient,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          onSettingsTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
          onInboxTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InboxScreen(),
              ),
            );
          },
          unreadCount: 3, // TODO: Get from provider
        ),
        body: IndexedStack(
          index: currentTabIndex,
          children: const [
            TodayTab(),
            FuelTab(),
            TrainTab(),
            MindTab(),
            EvolveTab(),
            TribeTab(),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(tabs.length, (index) {
                  final tab = tabs[index];
                  final isActive = currentTabIndex == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        ref.read(_currentTabProvider.notifier).state = index;
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              tab['icon'] as IconData,
                              color: isActive
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.7),
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tab['label'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight:
                                    isActive ? FontWeight.w600 : FontWeight.normal,
                                color: isActive
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

