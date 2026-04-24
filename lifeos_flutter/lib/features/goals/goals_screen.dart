import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/neon_text.dart';
import '../../providers/goals_provider.dart';
import '../system/empty_state_screen.dart';
import 'add_edit_goal_screen.dart';
import 'goal_detail_screen.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const NeonText(
          'GOAL ARCHITECTURE',
          color: AppTheme.textPrimary,
          glow: false,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Add goal',
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppTheme.neonCyan,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditGoalScreen()),
              );
            },
          ),
        ],
      ),
      body: goals.isEmpty
          ? const EmptyStateScreen(
              title: 'No Protocols Found',
              subtitle:
                  'Initialize a new goal protocol to begin tracking progress.',
              icon: Icons.track_changes,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GlassCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GoalDetailScreen(goalId: goal.id),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              goal.category.toUpperCase(),
                              style: const TextStyle(
                                color: AppTheme.primaryPurple,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              '${(goal.progress * 100).toInt()}%',
                              style: const TextStyle(
                                color: AppTheme.neonCyan,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          goal.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: goal.progress,
                          backgroundColor: AppTheme.surfaceElevated,
                          color: AppTheme.neonCyan,
                          borderRadius: BorderRadius.circular(4),
                          minHeight: 6,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
