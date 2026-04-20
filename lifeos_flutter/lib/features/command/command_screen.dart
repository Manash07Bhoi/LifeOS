import '../../shared/widgets/shake_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/command_provider.dart';
import '../focus/focus_screen.dart';
import '../analytics/analytics_screen.dart';
import 'command_dictionary_screen.dart';
import 'hacker_log_overlay.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/command_history.dart';
import '../../providers/goals_provider.dart';
import '../../providers/habits_provider.dart';
import '../goals/goals_screen.dart';
import '../habits/habit_matrix_screen.dart';

class CommandScreen extends ConsumerStatefulWidget {
  const CommandScreen({super.key});

  @override
  ConsumerState<CommandScreen> createState() => _CommandScreenState();
}

class _CommandScreenState extends ConsumerState<CommandScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _errorText = '';
  bool _isProcessing = false;
  List<String> _currentLogs = [];

  final List<String> _suggestions = [
    'help',
    'add goal',
    'create new habit',
    'start focus',
    'ls'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _processCommand(String cmd) async {
    if (cmd.trim().isEmpty || _isProcessing) return;

    final lower = cmd.trim().toLowerCase();
    bool success = false;

    setState(() {
      _isProcessing = true;
      _errorText = '';
    });

    void finishProcess(bool isSuccess, [List<String>? logs, VoidCallback? onComplete]) {
      success = isSuccess;
      ref.read(commandProvider.notifier).addCommand(cmd, wasSuccessful: success);

      if (success) _controller.clear();

      if (logs != null && logs.isNotEmpty) {
        setState(() {
           _currentLogs = logs;
        });
      } else {
        setState(() => _isProcessing = false);
        if (onComplete != null) onComplete();
      }
    }

    // Command Logic
    if (lower == 'help' || lower == '-h') {
      finishProcess(true, [
        'Fetching manual...',
        'Accessing command dictionary...'
      ]);
    } else if (lower == 'ls') {
      final goals = ref.read(goalsProvider).length;
      final habits = ref.read(habitsProvider).length;
      finishProcess(true, [
        'Scanning directory structure...',
        'modules/',
        ' ├─ goals [$goals]',
        ' ├─ habits [$habits]',
        ' └─ analytics',
      ]);
    } else if (lower.startsWith('cd ')) {
      final module = lower.split('cd ').last.trim();
      if (module == 'goals') {
        finishProcess(true, ['Navigating to module: goals...'], () {
          _closeOverlay();
          Navigator.push(context, MaterialPageRoute(builder: (_) => const GoalsScreen()));
        });
      } else if (module == 'habits') {
        finishProcess(true, ['Navigating to module: habits...'], () {
          _closeOverlay();
          Navigator.push(context, MaterialPageRoute(builder: (_) => const HabitMatrixScreen()));
        });
      } else if (module == 'analytics') {
        finishProcess(true, ['Navigating to module: analytics...'], () {
          _closeOverlay();
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalyticsScreen()));
        });
      } else {
        finishProcess(false, ['cd: $module: No such file or directory']);
      }
    } else if (lower.contains('goal') && (lower.contains('add') || lower.contains('create'))) {
      finishProcess(true, [
        'Initializing goal creation protocol...',
        'Allocating memory space...'
      ], () {
        _closeOverlay();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) Navigator.pushNamed(context, '/add_goal');
        });
      });
    } else if (lower.contains('habit') && (lower.contains('add') || lower.contains('create'))) {
      finishProcess(true, [
        'Initializing habit creation protocol...',
        'Allocating memory space...'
      ], () {
        _closeOverlay();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) Navigator.pushNamed(context, '/add_habit');
        });
      });
    } else if (lower.contains('focus') && lower.contains('start')) {
      finishProcess(true, [
        'Engaging Deep Focus mode...',
        'Disabling external interruptions...'
      ], () {
        _closeOverlay();
        Navigator.push(context, MaterialPageRoute(builder: (_) => const FocusScreen()));
      });
    } else if (lower == 'clear') {
      await Hive.box<CommandHistory>('commandHistoryBox').clear();
      finishProcess(true, ['Clearing terminal buffer...', 'Buffer cleared.']);
    } else if (lower == 'history') {
      finishProcess(true, [
        'Accessing command history...'
      ]);
    } else if (lower == 'status') {
      finishProcess(true, [
        'Running system diagnostics...',
        'Status: ONLINE',
        'Storage: STABLE',
        'All modules operational.'
      ]);
    } else {
      finishProcess(false);
      setState(() {
        _errorText = 'bash: $cmd: command not found\nTry "help" or "-h" for a list of commands.';
      });
    }
  }

  void _closeOverlay() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(commandProvider);
    final isError = _errorText.isNotEmpty;

    return Scaffold(
      backgroundColor: AppTheme.background.withValues(alpha: 0.95),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  tooltip: 'Close',
                  icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                  onPressed: _closeOverlay,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Lifeos@operator:~\$',
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: AppTheme.neonCyan,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (_isProcessing && _currentLogs.isNotEmpty)
                Expanded(
                  child: HackerLogOverlay(
                    logs: _currentLogs,
                    onComplete: () {
                      setState(() {
                        _isProcessing = false;
                        _currentLogs = [];
                      });

                      // Finalize actions
                      final cmd = history.first.commandText.trim().toLowerCase();
                      if (cmd == 'help' || cmd == '-h') {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CommandDictionaryScreen()));
                      }
                    },
                  ),
                )
              else
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a command...',
                  hintStyle: TextStyle(
                    color: AppTheme.textSecondary.withValues(alpha: 0.3),
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.chevron_right,
                    color: isError ? AppTheme.neonPink : AppTheme.neonCyan,
                    size: 32,
                  ),
                ),
                onSubmitted: _processCommand,
                onChanged: (val) {
                  if (isError) {
                    setState(() => _errorText = '');
                  }
                },
              ),

              if (isError && !_isProcessing) ...[
                const SizedBox(height: 16),
                ShakeWidget(
                  shouldShake: isError,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.neonPink.withValues(alpha: 0.1),
                      border: Border.all(color: AppTheme.neonPink.withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.error_outline, color: AppTheme.neonPink),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorText,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              color: AppTheme.neonPink,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 40),

              const Text(
                'SUGGESTIONS',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _suggestions.map((s) => ActionChip(
                  label: Text(s),
                  backgroundColor: AppTheme.surfaceElevated,
                  labelStyle: const TextStyle(color: AppTheme.textPrimary),
                  onPressed: () {
                    _controller.text = s;
                    _processCommand(s);
                  },
                )).toList(),
              ),

              if (!_isProcessing) ...[
                const SizedBox(height: 40),
                const Text(
                  'COMMAND HISTORY',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final cmd = history[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            Icon(
                              cmd.wasSuccessful ? Icons.check_circle_outline : Icons.cancel_outlined,
                              color: cmd.wasSuccessful ? AppTheme.primaryPurple : AppTheme.textSecondary,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              cmd.commandText,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                color: cmd.wasSuccessful ? AppTheme.textPrimary : AppTheme.textSecondary,
                                decoration: cmd.wasSuccessful ? null : TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
