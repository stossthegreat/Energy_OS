import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/energy_provider.dart';
import '../../utils/theme.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final briefs = ref.watch(briefsProvider);
    final recommendations = ref.watch(recommendationsProvider(null));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(briefsProvider);
          ref.invalidate(recommendationsProvider(null));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Briefs Section
              const Text(
                'Briefs & Nudges',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              briefs.when(
                data: (briefsList) => briefsList.isEmpty
                    ? _buildEmptyState('No briefs yet')
                    : Column(
                        children: briefsList
                            .map((brief) => _buildBriefCard(context, brief))
                            .toList(),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => _buildEmptyState('Error loading briefs'),
              ),

              const SizedBox(height: 32),

              // Saved Recommendations Section
              const Text(
                'Saved Plans',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              recommendations.when(
                data: (recsList) => recsList.isEmpty
                    ? _buildEmptyState('No saved plans')
                    : Column(
                        children: recsList
                            .map((rec) => _buildRecommendationCard(context, rec))
                            .toList(),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => _buildEmptyState('Error loading plans'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBriefCard(BuildContext context, brief) {
    final kindEmojis = {
      'morning': '☀️',
      'evening': '🌙',
      'monthly': '📊',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // TODO: Navigate to brief detail
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      kindEmojis[brief.kind] ?? '📢',
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${brief.kind[0].toUpperCase()}${brief.kind.substring(1)} Brief',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM d, h:mm a').format(brief.createdAt),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, rec) {
    final tabIcons = {
      'mind': Icons.psychology,
      'train': Icons.fitness_center,
      'fuel': Icons.restaurant,
      'evolve': Icons.auto_awesome,
    };

    final tabColors = {
      'mind': const Color(0xFF818cf8),
      'train': const Color(0xFFa78bfa),
      'fuel': const Color(0xFF34d399),
      'evolve': const Color(0xFF60a5fa),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // TODO: Navigate to recommendation detail
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: (tabColors[rec.tab] ?? Colors.white).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    tabIcons[rec.tab] ?? Icons.bookmark,
                    color: tabColors[rec.tab] ?? Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rec.query ?? 'Saved Recommendation',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${rec.tab[0].toUpperCase()}${rec.tab.substring(1)} • ${DateFormat('MMM d').format(rec.createdAt)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.4),
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

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.4),
          ),
        ),
      ),
    );
  }
}

