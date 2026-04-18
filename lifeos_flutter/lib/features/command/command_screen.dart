import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/neon_text.dart';
import '../../providers/command_provider.dart';
import '../focus/focus_screen.dart';
import '../analytics/analytics_screen.dart';

class CommandScreen extends ConsumerStatefulWidget {
  const CommandScreen({super.key});

  @override
  ConsumerState<CommandScreen> createState() => _CommandScreenState();
}

class _CommandScreenState extends ConsumerState<CommandScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _errorText = '';

  final List<String> _suggestions = [
    'add goal',
    'create new habit',
    'start focus',
    'show analytics'
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

  void _processCommand(String cmd) {
    if (cmd.trim().isEmpty) return;

    final lower = cmd.toLowerCase();
    bool success = false;

    if (lower.contains('goal') && (lower.contains('add') || lower.contains('create'))) {
      success = true;
      _closeOverlay();
      WidgetsBinding.instance.addPostFrameCallback((_) {
         if (context.mounted) {
            Navigator.pushNamed(context, '/add_goal');
         }
      });
    } else if (lower.contains('habit') && (lower.contains('add') || lower.contains('create'))) {
      success = true;
      _closeOverlay();
      WidgetsBinding.instance.addPostFrameCallback((_) {
         if (context.mounted) {
            Navigator.pushNamed(context, '/add_habit');
         }
      });
    } else if (lower.contains('focus') && lower.contains('start')) {
      success = true;
      _closeOverlay();
      Navigator.push(context, MaterialPageRoute(builder: (_) => const FocusScreen()));
    } else if (lower.contains('analytics') && lower.contains('show')) {
      success = true;
      _closeOverlay();
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalyticsScreen()));
    } else {
      setState(() {
        _errorText = 'UNKNOWN COMMAND: "$cmd". TRY SUGGESTIONS BELOW.';
      });
    }

    ref.read(commandProvider.notifier).addCommand(cmd, wasSuccessful: success);
    if (success) _controller.clear();
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
                  icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                  onPressed: _closeOverlay,
                ),
              ),
              const SizedBox(height: 40),
              const NeonText(
                'AWAITING INPUT...',
                color: AppTheme.neonCyan,
                fontSize: 12,
              ),
              const SizedBox(height: 8),
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

              if (isError) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.neonPink.withValues(alpha: 0.1),
                    border: Border.all(color: AppTheme.neonPink.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppTheme.neonPink),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorText,
                          style: const TextStyle(color: AppTheme.neonPink, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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
                              color: cmd.wasSuccessful ? AppTheme.textPrimary : AppTheme.textSecondary,
                              decoration: cmd.wasSuccessful ? null : TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
