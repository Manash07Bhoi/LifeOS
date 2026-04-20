import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/neon_text.dart';
import '../../providers/routines_provider.dart';
import '../../providers/habits_provider.dart';
import '../../providers/focus_provider.dart';
import '../../data/models/routine.dart';
import '../../shared/components/success_feedback_toast.dart';
import '../../shared/components/confirmation_dialog.dart';
import '../focus/focus_screen.dart';
import 'create_routine_screen.dart';

class RoutineListScreen extends ConsumerWidget {
  const RoutineListScreen({super.key});

  void _onRunRoutine(BuildContext context, WidgetRef ref, Routine routine) async {
    // STEP 1 - VALIDATION
    if (routine.linkedHabits.isEmpty && routine.focusDuration <= 0) {
      SuccessFeedbackToast.show(context, 'Routine has no habits and no focus duration.', isError: true);
      return;
    }

    // STEP 2 - PRECHECK
    final focusState = ref.read(focusProvider);
    if (focusState.status == FocusState.running || focusState.status == FocusState.paused) {
      final override = await ConfirmationDialog.show(
        context,
        title: 'SESSION ACTIVE',
        message: 'A focus session is already active. Abort current session and start routine?',
        isDestructive: true,
        confirmText: 'START',
      );
      if (override != true) return;
    }

    if (!context.mounted) return;

    try {
      // STEP 3 - EXECUTION (ATOMIC)
      // Execute Habits
      final allHabits = ref.read(habitsProvider);
      final today = DateTime.now();
      for (String habitId in routine.linkedHabits) {
        final habit = allHabits.firstWhere((h) => h.id == habitId);
        if (!habit.isCompletedOn(today)) {
          ref.read(habitsProvider.notifier).toggleCompletion(habitId, today);
        }
      }

      // Start Focus Session
      if (routine.focusDuration > 0) {
        ref.read(focusProvider.notifier).resetTimer();
        ref.read(focusProvider.notifier).setDuration(routine.focusDuration);
        ref.read(focusProvider.notifier).startTimer();
      }

      // STEP 4 - STATE UPDATE
      ref.invalidate(habitsProvider);
      // focusProvider updates itself via StateNotifier mutations
      ref.invalidate(focusSessionsProvider); // equivalent to analyticsProvider context

      // STEP 5 - FEEDBACK & NAVIGATION
      if (!context.mounted) return;
      SuccessFeedbackToast.show(context, 'Routine executed successfully.');

      if (routine.focusDuration > 0) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FocusScreen()));
      }
    } catch (e) {
      if (context.mounted) {
        SuccessFeedbackToast.show(context, 'Failed to execute routine securely.', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routines = ref.watch(routinesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const NeonText('TASK AUTOMATION', color: AppTheme.textPrimary, glow: false),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryPurple,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateRoutineScreen()));
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: routines.isEmpty
            ? const Center(
                child: Text('No routines found. Initialize one.', style: TextStyle(color: AppTheme.textSecondary)),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: routines.length,
                itemBuilder: (context, index) {
                  final routine = routines[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GlassCard(
                      child: ListTile(
                        leading: const Icon(Icons.memory, color: AppTheme.neonCyan),
                        title: Text(routine.name, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
                        subtitle: Text('${routine.linkedHabits.length} Tasks | ${routine.focusDuration}m Focus', style: const TextStyle(color: AppTheme.textSecondary)),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_arrow, color: AppTheme.neonPink),
                          onPressed: () => _onRunRoutine(context, ref, routine),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
