import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/components/add_edit_unified_form_screen.dart';
import '../../shared/components/confirmation_dialog.dart';
import '../../data/models/habit.dart';
import '../../providers/habits_provider.dart';

class AddEditHabitScreen extends ConsumerStatefulWidget {
  final Habit? existingHabit;

  const AddEditHabitScreen({super.key, this.existingHabit});

  @override
  ConsumerState<AddEditHabitScreen> createState() => _AddEditHabitScreenState();
}

class _AddEditHabitScreenState extends ConsumerState<AddEditHabitScreen> {
  int _frequencyDays = 7;

  @override
  void initState() {
    super.initState();
    if (widget.existingHabit != null) {
      _frequencyDays = widget.existingHabit!.frequencyDays;
    }
  }

  void _saveHabit(String name, String description) {
    final habit = Habit(
      id: widget.existingHabit?.id,
      title: name,
      description: description,
      frequencyDays: _frequencyDays,
      completionDates: widget.existingHabit?.completionDates,
      streak: widget.existingHabit?.streak ?? 0,
      createdAt: widget.existingHabit?.createdAt,
    );

    if (widget.existingHabit == null) {
      ref.read(habitsProvider.notifier).addHabit(habit);
    } else {
      ref.read(habitsProvider.notifier).updateHabit(habit);
    }
    Navigator.pop(context);
  }

  void _deleteHabit() {
    if (widget.existingHabit != null) {
      ConfirmationDialog.show(
        context,
        title: 'DELETE HABIT?',
        message: 'Are you sure you want to delete this habit?',
        isDestructive: true,
        confirmText: 'DELETE',
      ).then((confirmed) {
        if (confirmed == true) {
          final id = widget.existingHabit!.id;
          ref.read(habitsProvider.notifier).deleteHabit(id);
          if (mounted) {
            Navigator.pop(context);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingHabit != null;

    return AddEditUnifiedFormScreen(
      title: isEditing ? 'EDIT HABIT' : 'NEW HABIT',
      entityName: 'HABIT',
      nameLabel: 'HABIT IDENTIFIER',
      nameHint: 'e.g., Morning Meditation',
      descLabel: 'PARAMETERS',
      descHint: 'Define context or rules...',
      submitText: isEditing ? 'UPDATE HABIT' : 'INITIALIZE HABIT',
      initialName: widget.existingHabit?.title ?? '',
      initialDesc: widget.existingHabit?.description ?? '',
      onSubmit: _saveHabit,
      onDelete: isEditing ? _deleteHabit : null,
      extraFields: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('WEEKLY FREQUENCY', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Days per week:', style: TextStyle(color: AppTheme.textPrimary, fontSize: 16)),
              Row(
                children: [
                  IconButton(
                    onPressed: _frequencyDays > 1 ? () => setState(() => _frequencyDays--) : null,
                    icon: const Icon(Icons.remove_circle_outline, color: AppTheme.neonCyan),
                  ),
                  Text('$_frequencyDays', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: _frequencyDays < 7 ? () => setState(() => _frequencyDays++) : null,
                    icon: const Icon(Icons.add_circle_outline, color: AppTheme.neonCyan),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
