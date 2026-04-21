import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/neon_text.dart';
import '../../providers/habits_provider.dart';
import '../system/empty_state_screen.dart';
import 'add_edit_habit_screen.dart';
import 'habit_list_item.dart';

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
            tooltip: 'Add habit',
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
                return HabitListItem(habit: habit, today: today);
              },
            ),
    );
  }
}
