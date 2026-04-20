import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/glow_button.dart';
import '../../shared/widgets/custom_input_field.dart';
import '../../data/models/routine.dart';
import '../../providers/routines_provider.dart';
import '../../providers/habits_provider.dart';

class CreateRoutineScreen extends ConsumerStatefulWidget {
  final Routine? existingRoutine;

  const CreateRoutineScreen({super.key, this.existingRoutine});

  @override
  ConsumerState<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends ConsumerState<CreateRoutineScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  int _focusDuration = 25;
  List<String> _selectedHabits = [];

  @override
  void initState() {
    super.initState();
    if (widget.existingRoutine != null) {
      _nameController.text = widget.existingRoutine!.name;
      _notesController.text = widget.existingRoutine!.notes;
      _focusDuration = widget.existingRoutine!.focusDuration;
      _selectedHabits = List.from(widget.existingRoutine!.linkedHabits);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveRoutine() {
    if (_nameController.text.trim().isEmpty) return;

    final r = Routine(
      id: widget.existingRoutine?.id,
      name: _nameController.text.trim(),
      notes: _notesController.text.trim(),
      focusDuration: _focusDuration,
      linkedHabits: _selectedHabits,
    );

    if (widget.existingRoutine == null) {
      ref.read(routinesProvider.notifier).addRoutine(r);
    } else {
      ref.read(routinesProvider.notifier).updateRoutine(r);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final allHabits = ref.watch(habitsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.existingRoutine == null ? 'BUILD ROUTINE' : 'EDIT ROUTINE', style: const TextStyle(fontFamily: 'Plus Jakarta Sans', color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInputField(
                controller: _nameController,
                hintText: 'e.g., Morning Protocol',
              ),
              const SizedBox(height: 24),
              const Text('FOCUS DURATION (MINUTES)', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1.5)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _focusDuration > 5 ? () => setState(() => _focusDuration -= 5) : null,
                    icon: const Icon(Icons.remove_circle_outline, color: AppTheme.neonCyan),
                  ),
                  Text('$_focusDuration', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 32, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: _focusDuration < 120 ? () => setState(() => _focusDuration += 5) : null,
                    icon: const Icon(Icons.add_circle_outline, color: AppTheme.neonCyan),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text('LINKED HABITS', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1.5)),
              const SizedBox(height: 16),
              if (allHabits.isEmpty)
                 const Text('No habits available to link. Create some first.', style: TextStyle(color: AppTheme.textSecondary))
              else
                ...allHabits.map((h) {
                  final isLinked = _selectedHabits.contains(h.id);
                  return CheckboxListTile(
                    activeColor: AppTheme.primaryPurple,
                    checkColor: Colors.white,
                    side: const BorderSide(color: AppTheme.textSecondary),
                    title: Text(h.title, style: const TextStyle(color: AppTheme.textPrimary)),
                    value: isLinked,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedHabits.add(h.id);
                        } else {
                          _selectedHabits.remove(h.id);
                        }
                      });
                    },
                  );
                }),
              const SizedBox(height: 32),
              CustomInputField(
                controller: _notesController,
                hintText: 'Routine notes...',
                maxLines: 3,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: GlowButton(
                  text: widget.existingRoutine == null ? 'INITIALIZE ROUTINE' : 'UPDATE ROUTINE',
                  color: AppTheme.primaryPurple,
                  onPressed: _saveRoutine,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
