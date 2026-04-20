import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/neon_text.dart';
import '../system/offline_state_banner.dart';
import '../../providers/goals_provider.dart';
import '../../providers/habits_provider.dart';
import '../../data/models/goal.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider);
    final habits = ref.watch(habitsProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const OfflineStateBanner(),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _DashboardHeader(),
                          const SizedBox(height: 32),
                          _DashboardSummary(
                            goalCount: goals.length,
                            habitCount: habits.length,
                          ),
                          const SizedBox(height: 32),
                          _ActiveProtocols(goals: goals),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NeonText(
          'SYSTEM STATUS',
          color: AppTheme.neonCyan,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        Text(
          'Dashboard',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ],
    );
  }
}

class _DashboardSummary extends StatelessWidget {
  final int goalCount;
  final int habitCount;

  const _DashboardSummary({
    required this.goalCount,
    required this.habitCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.track_changes, color: AppTheme.primaryPurple),
                const SizedBox(height: 16),
                Text(
                  '$goalCount',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Text(
                  'Active Goals',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.loop, color: AppTheme.neonCyan),
                const SizedBox(height: 16),
                Text(
                  '$habitCount',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Text(
                  'Habits Tracked',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActiveProtocols extends StatelessWidget {
  final List<Goal> goals;

  const _ActiveProtocols({required this.goals});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const NeonText(
          'ACTIVE PROTOCOLS',
          color: AppTheme.primaryPurple,
          fontSize: 14,
        ),
        const SizedBox(height: 16),
        ...goals.take(2).map((g) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _GoalCard(goal: g),
            )),
        if (goals.isEmpty)
          const GlassCard(
            child: Center(
              child: Text('No active goals detected.'),
            ),
          )
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final Goal goal;

  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: AppTheme.primaryPurple,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              goal.title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '${(goal.progress * 100).toInt()}%',
            style: const TextStyle(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
