import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/neon_text.dart';
import '../../shared/components/confirmation_dialog.dart';
import '../../providers/goals_provider.dart';
import 'add_edit_goal_screen.dart';
import '../../core/utils/date_formats.dart';

class GoalDetailScreen extends ConsumerWidget {
  final String goalId;

  const GoalDetailScreen({super.key, required this.goalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider);
    final goal = goals.firstWhere((g) => g.id == goalId, orElse: () => goals.first);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Edit goal',
            icon: const Icon(Icons.edit, color: AppTheme.textSecondary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddEditGoalScreen(existingGoal: goal)),
              );
            },
          ),
          IconButton(
            tooltip: 'Delete goal',
            icon: const Icon(Icons.delete_outline, color: AppTheme.neonPink),
            onPressed: () {
              ConfirmationDialog.show(
                context,
                title: 'TERMINATE PROTOCOL?',
                message: 'This action will permanently delete this goal from local storage.',
                isDestructive: true,
                confirmText: 'TERMINATE',
              ).then((confirmed) {
                if (confirmed == true && context.mounted) {
                  ref.read(goalsProvider.notifier).deleteGoal(goalId);
                  Navigator.pop(context);
                }
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                goal.category.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.primaryPurple,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                goal.title,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 32),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('COMPLETION STATUS', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1.5)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        NeonText('${(goal.progress * 100).toInt()}%', color: AppTheme.neonCyan, fontSize: 48),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: goal.progress,
                      backgroundColor: AppTheme.surface,
                      color: AppTheme.neonCyan,
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 8,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.surfaceElevated, foregroundColor: AppTheme.textPrimary),
                            onPressed: goal.progress > 0 ? () {
                              ref.read(goalsProvider.notifier).updateGoal(goal.copyWith(progress: (goal.progress - 0.1).clamp(0.0, 1.0)));
                            } : null,
                            child: const Text('-10%'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.surfaceElevated, foregroundColor: AppTheme.textPrimary),
                            onPressed: goal.progress < 1.0 ? () {
                              ref.read(goalsProvider.notifier).updateGoal(goal.copyWith(progress: (goal.progress + 0.1).clamp(0.0, 1.0)));
                            } : null,
                            child: const Text('+10%'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text('PARAMETERS', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1.5)),
              const SizedBox(height: 12),
              Text(
                goal.description.isEmpty ? 'No parameters defined.' : goal.description,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 32),
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppTheme.primaryPurple),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TARGET DEADLINE', style: TextStyle(color: AppTheme.textSecondary, fontSize: 10, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Text(
                          AppDateFormats.standard.format(goal.targetDate),
                          style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
