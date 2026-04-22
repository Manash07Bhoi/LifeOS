import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/neon_text.dart';

class CommandDictionaryScreen extends StatelessWidget {
  const CommandDictionaryScreen({super.key});

  final List<Map<String, String>> _commands = const [
    {
      'cmd': 'help | -h',
      'desc': 'List all available commands and operations.',
      'example': 'help'
    },
    {
      'cmd': 'ls',
      'desc': 'List core system modules and active states.',
      'example': 'ls'
    },
    {
      'cmd': 'cd <module>',
      'desc': 'Navigate into a specific module directly.',
      'example': 'cd goals'
    },
    {
      'cmd': 'add goal',
      'desc': 'Initialize the protocol to establish a new goal.',
      'example': 'add goal'
    },
    {
      'cmd': 'add habit',
      'desc': 'Initialize the protocol to establish a new habit.',
      'example': 'add habit'
    },
    {
      'cmd': 'start focus',
      'desc': 'Engage Deep Focus timer mode.',
      'example': 'start focus'
    },
    {
      'cmd': 'clear',
      'desc': 'Clear all command history and logs from the terminal buffer.',
      'example': 'clear'
    },
    {
      'cmd': 'history',
      'desc': 'Output the system command execution history.',
      'example': 'history'
    },
    {
      'cmd': 'status',
      'desc': 'Output the current system operation and analytics state.',
      'example': 'status'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const NeonText('COMMAND DICTIONARY', color: AppTheme.textPrimary, glow: false),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: _commands.length,
          itemBuilder: (context, index) {
            final item = _commands[index];
            return _CommandListItem(
              cmd: item['cmd']!,
              desc: item['desc']!,
              example: item['example']!,
            );
          },
        ),
      ),
    );
  }
}

class _CommandListItem extends StatelessWidget {
  final String cmd;
  final String desc;
  final String example;

  const _CommandListItem({
    required this.cmd,
    required this.desc,
    required this.example,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GlassCard(
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            iconColor: AppTheme.neonCyan,
            collapsedIconColor: AppTheme.textSecondary,
            title: Text(
              cmd,
              style: const TextStyle(
                fontFamily: 'monospace',
                color: AppTheme.neonCyan,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      desc,
                      style: const TextStyle(color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.background.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.textSecondary.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        'Ex: $example',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
