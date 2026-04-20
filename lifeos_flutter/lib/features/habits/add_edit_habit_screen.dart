import 'package:flutter/material.dart';
import '../../shared/widgets/custom_input_field.dart';
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
  String _frequencyType = 'Daily';
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingHabit != null) {
      _frequencyDays = widget.existingHabit!.frequencyDays;
      _frequencyType = widget.existingHabit!.frequencyType;
      _notesController.text = widget.existingHabit!.notes;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _saveHabit(String name, String description) {
    final habit = Habit(
      id: widget.existingHabit?.id,
      title: name,
      description: description,
      frequencyDays: _frequencyDays,
      frequencyType: _frequencyType,
      notes: _notesController.text,
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
          const Text('FREQUENCY TYPE', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['Daily', 'Weekly', 'Custom'].map((t) {
              final isSelected = _frequencyType == t;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _frequencyType = t),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.neonCyan.withValues(alpha: 0.2) : AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? AppTheme.neonCyan : Colors.transparent),
                    ),
                    alignment: Alignment.center,
                    child: Text(t, style: TextStyle(color: isSelected ? AppTheme.neonCyan : AppTheme.textSecondary, fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text('TARGET DAYS PER WEEK', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Days:', style: TextStyle(color: AppTheme.textPrimary, fontSize: 16)),
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
          ),
          const SizedBox(height: 24),
          const Text('ADDITIONAL NOTES', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          CustomInputField(
            controller: _notesController,
            hintText: 'E.g., Reminders or observations...',
            maxLines: 3,
            maxLength: 1000,
          ),
        ],
      ),
    );
  }
}
