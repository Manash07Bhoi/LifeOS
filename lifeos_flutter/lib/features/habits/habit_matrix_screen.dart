import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/neon_text.dart';
import '../../providers/habits_provider.dart';
import '../system/empty_state_screen.dart';
import 'add_edit_habit_screen.dart';

class HabitMatrixScreen extends ConsumerWidget {
  const HabitMatrixScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitsProvider);
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const NeonText('HABIT MATRIX', color: AppTheme.textPrimary, glow: false),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppTheme.neonCyan),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditHabitScreen()),
              );
            },
          ),
        ],
      ),
      body: habits.isEmpty
          ? const EmptyStateScreen(
              title: 'Matrix Offline',
              subtitle: 'No recurring habits found. Initialize a habit to track daily routines.',
              icon: Icons.loop,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                final isCompletedToday = habit.isCompletedOn(today);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref.read(habitsProvider.notifier).toggleCompletion(habit.id, today);
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isCompletedToday ? AppTheme.neonCyan : AppTheme.textSecondary,
                                width: 2,
                              ),
                              color: isCompletedToday ? AppTheme.neonCyan.withValues(alpha: 0.2) : Colors.transparent,
                              boxShadow: isCompletedToday
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.neonCyan.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      )
                                    ]
                                  : null,
                            ),
                            child: isCompletedToday
                                ? const Icon(Icons.check, color: AppTheme.neonCyan, size: 18)
                                : null,
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
                                  decoration: isCompletedToday ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              if (habit.description.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  habit.description,
                                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                                ),
                              ]
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.local_fire_department, color: AppTheme.neonPink, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${habit.streak}',
                              style: const TextStyle(color: AppTheme.neonPink, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.edit, color: AppTheme.textSecondary, size: 20),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => AddEditHabitScreen(existingHabit: habit)),
                            );
                          },
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
