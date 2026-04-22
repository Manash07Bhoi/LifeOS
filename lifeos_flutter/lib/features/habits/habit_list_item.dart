import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/habit.dart';
import '../../shared/widgets/glass_card.dart';
import '../../providers/habits_provider.dart';
import 'add_edit_habit_screen.dart';

class HabitListItem extends ConsumerWidget {
  final Habit habit;
  final DateTime today;

  const HabitListItem({super.key, required this.habit, required this.today});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompletedToday = habit.isCompletedOn(today);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Tooltip(
              message: isCompletedToday
                  ? 'Mark as incomplete'
                  : 'Mark as complete',
              child: GestureDetector(
                onTap: () {
                  ref
                      .read(habitsProvider.notifier)
                      .toggleCompletion(habit.id, today);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompletedToday
                          ? AppTheme.neonCyan
                          : AppTheme.textSecondary,
                      width: 2,
                    ),
                    color: isCompletedToday
                        ? AppTheme.neonCyan.withValues(alpha: 0.2)
                        : Colors.transparent,
                    boxShadow: isCompletedToday
                        ? [
                            BoxShadow(
                              color: AppTheme.neonCyan.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: isCompletedToday
                      ? const Icon(
                          Icons.check,
                          color: AppTheme.neonCyan,
                          size: 18,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                      decoration: isCompletedToday
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (habit.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      habit.description,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: AppTheme.neonPink,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${habit.streak}',
                  style: const TextStyle(
                    color: AppTheme.neonPink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Edit habit',
              icon: const Icon(
                Icons.edit,
                color: AppTheme.textSecondary,
                size: 20,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditHabitScreen(existingHabit: habit),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
