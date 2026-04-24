import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/neon_text.dart';
import 'theme_preview_screen.dart';
import 'about_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/goal.dart';
import '../../data/models/habit.dart';
import '../../data/models/focus_session.dart';
import '../../data/models/command_history.dart';
import '../../shared/components/confirmation_dialog.dart';
import '../../shared/components/success_feedback_toast.dart';
import '../../providers/goals_provider.dart';
import '../../providers/habits_provider.dart';
import '../../providers/focus_provider.dart';
import '../../providers/command_provider.dart';
import '../navigation/navigation_wrapper_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const NeonText(
          'SYSTEM CONFIGURATION',
          color: AppTheme.textPrimary,
          glow: false,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            const _AppearanceSection(),
            const SizedBox(height: 32),
            _DataManagementSection(
              onPurgeData: () => _showDataResetConfirm(context, ref),
            ),
            const SizedBox(height: 32),
            const _SystemInfoSection(),
          ],
        ),
      ),
    );
  }

  void _showDataResetConfirm(BuildContext context, WidgetRef ref) {
    ConfirmationDialog.show(
      context,
      title: 'PURGE ALL DATA?',
      message:
          'This will delete all goals, habits, sessions, and command history. This cannot be undone.',
      isDestructive: true,
      confirmText: 'PURGE',
    ).then((confirmed) async {
      if (confirmed == true) {
        try {
          // Step 1: Clear all Hive boxes (preserves encryption ciphers)
          await Hive.box<Goal>('goalsBox').clear();
          await Hive.box<Habit>('habitsBox').clear();
          await Hive.box<FocusSession>('sessionsBox').clear();
          await Hive.box<CommandHistory>('commandHistoryBox').clear();
          await Hive.box('settingsBox').clear();

          // Step 2: Invalidate Riverpod Providers
          ref.invalidate(goalsProvider);
          ref.invalidate(habitsProvider);
          ref.invalidate(focusProvider);
          ref.invalidate(focusSessionsProvider); // Serves as analyticsProvider
          ref.invalidate(commandProvider);
          // Note: settingsProvider and analyticsProvider do not technically exist as separate state notifiers in this codebase structure.
          // focusSessionsProvider drives the analytics view entirely, so invalidating it serves the same purpose.

          if (!context.mounted) return;

          SuccessFeedbackToast.show(context, 'System reset complete');

          // Step 4: Navigate user to clean state (Dashboard via NavigationWrapperScreen)
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const NavigationWrapperScreen()),
            (route) => false,
          );
        } catch (e) {
          if (!context.mounted) return;
          SuccessFeedbackToast.show(
            context,
            'Failed to purge data securely.',
            isError: true,
          );
        }
      }
    });
  }
}

class _AppearanceSection extends StatelessWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'APPEARANCE',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.palette_outlined,
                  color: AppTheme.primaryPurple,
                ),
                title: const Text(
                  'Theme Preview',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
                subtitle: const Text(
                  'Accent Color Selector',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppTheme.textSecondary,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ThemePreviewScreen(),
                    ),
                  );
                },
              ),
              const Divider(color: Colors.white12, height: 1),
              SwitchListTile(
                activeTrackColor: AppTheme.neonCyan.withValues(alpha: 0.3),
                activeThumbColor: AppTheme.neonCyan,
                secondary: const Icon(
                  Icons.animation,
                  color: AppTheme.neonCyan,
                ),
                title: const Text(
                  'Animation Engine',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
                subtitle: const Text(
                  'High / Low Performance Toggle',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                value: true,
                onChanged: (val) {
                  SuccessFeedbackToast.show(
                    context,
                    'Core animations locked to high-performance profile.',
                    isError: false,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DataManagementSection extends StatelessWidget {
  final VoidCallback onPurgeData;

  const _DataManagementSection({required this.onPurgeData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DATA MANAGEMENT',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.sd_storage_outlined,
                  color: AppTheme.neonCyan,
                ),
                title: const Text(
                  'Export Local Data',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
                subtitle: const Text(
                  'Save Hive boxes to JSON',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
                trailing: const Icon(
                  Icons.download,
                  color: AppTheme.textSecondary,
                ),
                onTap: () {
                  SuccessFeedbackToast.show(
                    context,
                    'Data Export capability not available in core build.',
                    isError: true,
                  );
                },
              ),
              const Divider(color: Colors.white12, height: 1),
              ListTile(
                leading: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppTheme.neonPink,
                ),
                title: const Text(
                  'Purge System Data',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
                subtitle: const Text(
                  'Irreversible action',
                  style: TextStyle(color: AppTheme.neonPink),
                ),
                onTap: onPurgeData,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SystemInfoSection extends StatelessWidget {
  const _SystemInfoSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SYSTEM INFO',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: ListTile(
            leading: const Icon(
              Icons.info_outline,
              color: AppTheme.textSecondary,
            ),
            title: const Text(
              'About LifeOS',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondary,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
        ),
      ],
    );
  }
}
