import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/components/add_edit_unified_form_screen.dart';
import '../../data/models/goal.dart';
import '../../providers/goals_provider.dart';
import '../../core/utils/date_formats.dart';

class AddEditGoalScreen extends ConsumerStatefulWidget {
  final Goal? existingGoal;

  const AddEditGoalScreen({super.key, this.existingGoal});

  @override
  ConsumerState<AddEditGoalScreen> createState() => _AddEditGoalScreenState();
}

class _AddEditGoalScreenState extends ConsumerState<AddEditGoalScreen> {
  DateTime _targetDate = DateTime.now().add(const Duration(days: 30));
  String _priority = 'Medium';

  @override
  void initState() {
    super.initState();
    if (widget.existingGoal != null) {
      _targetDate = widget.existingGoal!.targetDate;
      _priority = widget.existingGoal!.priority;
    }
  }

  void _saveGoal(String name, String description) {
    final goal = Goal(
      id: widget.existingGoal?.id,
      title: name,
      description: description,
      category: 'General',
      priority: _priority,
      targetDate: _targetDate,
      progress: widget.existingGoal?.progress ?? 0.0,
      createdAt: widget.existingGoal?.createdAt,
    );

    if (widget.existingGoal == null) {
      ref.read(goalsProvider.notifier).addGoal(goal);
    } else {
      ref.read(goalsProvider.notifier).updateGoal(goal);
    }
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryPurple,
              onPrimary: Colors.white,
              surface: AppTheme.surfaceElevated,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _targetDate) {
      setState(() {
        _targetDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingGoal != null;

    return AddEditUnifiedFormScreen(
      title: isEditing ? 'EDIT PROTOCOL' : 'NEW PROTOCOL',
      entityName: 'PROTOCOL',
      nameLabel: 'PROTOCOL IDENTIFIER',
      nameHint: 'e.g., Master Flutter',
      descLabel: 'PARAMETERS',
      descHint: 'Define execution strategy...',
      submitText: isEditing ? 'UPDATE PROTOCOL' : 'INITIALIZE PROTOCOL',
      initialName: widget.existingGoal?.title ?? '',
      initialDesc: widget.existingGoal?.description ?? '',
      onSubmit: _saveGoal,
      extraFields: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PRIORITY LEVEL',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['Low', 'Medium', 'High'].map((p) {
              final isSelected = _priority == p;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _priority = p),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryPurple.withValues(alpha: 0.2)
                          : AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryPurple
                            : Colors.transparent,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      p,
                      style: TextStyle(
                        color: isSelected
                            ? AppTheme.primaryPurple
                            : AppTheme.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'TARGET DATE',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppDateFormats.standard.format(_targetDate),
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today,
                    color: AppTheme.primaryPurple,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
