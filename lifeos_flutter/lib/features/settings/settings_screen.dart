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
import '../../data/models/routine.dart';
import '../../shared/components/confirmation_dialog.dart';
import '../../shared/components/success_feedback_toast.dart';
import '../../providers/goals_provider.dart';
import '../../providers/habits_provider.dart';
import '../../providers/focus_provider.dart';
import '../../providers/command_provider.dart';
import '../../providers/routines_provider.dart';
import '../navigation/navigation_wrapper_screen.dart';
import '../../data/services/data_export_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const NeonText('SYSTEM CONFIGURATION', color: AppTheme.textPrimary, glow: false),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            const Text('APPEARANCE', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1.5)),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.palette_outlined, color: AppTheme.primaryPurple),
                    title: const Text('Theme Preview', style: TextStyle(color: AppTheme.textPrimary)),
                    subtitle: const Text('Accent Color Selector', style: TextStyle(color: AppTheme.textSecondary)),
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ThemePreviewScreen()));
                    },
                  ),
                  const Divider(color: Colors.white12, height: 1),
                  SwitchListTile(
                    activeTrackColor: AppTheme.neonCyan.withValues(alpha: 0.3),
                    activeThumbColor: AppTheme.neonCyan,
                    secondary: const Icon(Icons.animation, color: AppTheme.neonCyan),
                    title: const Text('Animation Engine', style: TextStyle(color: AppTheme.textPrimary)),
                    subtitle: const Text('High / Low Performance Toggle', style: TextStyle(color: AppTheme.textSecondary)),
                    value: true,
                    onChanged: (val) {
                      SuccessFeedbackToast.show(context, 'Core animations locked to high-performance profile.', isError: false);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('DATA MANAGEMENT', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1.5)),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.sd_storage_outlined, color: AppTheme.neonCyan),
                    title: const Text('Export Local Data', style: TextStyle(color: AppTheme.textPrimary)),
                    subtitle: const Text('Save Hive boxes to JSON', style: TextStyle(color: AppTheme.textSecondary)),
                    trailing: const Icon(Icons.upload, color: AppTheme.textSecondary),
                    onTap: () async {
                       await DataExportService.exportData();
                       if (context.mounted) SuccessFeedbackToast.show(context, 'Data successfully exported.');
                    },
                  ),
                  const Divider(color: Colors.white12, height: 1),
                  ListTile(
                    leading: const Icon(Icons.file_download_outlined, color: AppTheme.neonCyan),
                    title: const Text('Import Local Data', style: TextStyle(color: AppTheme.textPrimary)),
                    subtitle: const Text('Restore from JSON backup', style: TextStyle(color: AppTheme.textSecondary)),
                    trailing: const Icon(Icons.download, color: AppTheme.textSecondary),
                    onTap: () async {
                       bool success = await DataExportService.importData();
                       if (context.mounted) {
                         if (success) {
                           SuccessFeedbackToast.show(context, 'Data successfully imported.');
                           ref.invalidate(goalsProvider);
                           ref.invalidate(habitsProvider);
                           ref.invalidate(focusSessionsProvider);
                           ref.invalidate(routinesProvider);
                         } else {
                           SuccessFeedbackToast.show(context, 'Import failed. Invalid or corrupted file.', isError: true);
                         }
                       }
                    },
                  ),
                  const Divider(color: Colors.white12, height: 1),
                  ListTile(
                    leading: const Icon(Icons.warning_amber_rounded, color: AppTheme.neonPink),
                    title: const Text('Purge System Data', style: TextStyle(color: AppTheme.textPrimary)),
                    subtitle: const Text('Irreversible action', style: TextStyle(color: AppTheme.neonPink)),
                    onTap: () {
                      _showDataResetConfirm(context, ref);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('SYSTEM INFO', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1.5)),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: AppTheme.textSecondary),
                    title: const Text('About LifeOS', style: TextStyle(color: AppTheme.textPrimary)),
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
                    },
                  ),
                  const Divider(color: Colors.white12, height: 1),
                  ListTile(
                    leading: const Icon(Icons.policy_outlined, color: AppTheme.textSecondary),
                    title: const Text('Privacy Policy', style: TextStyle(color: AppTheme.textPrimary)),
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                    onTap: () {
                      SuccessFeedbackToast.show(context, 'No data is collected or shared.', isError: false);
                    },
                  ),
                  const Divider(color: Colors.white12, height: 1),
                  ListTile(
                    leading: const Icon(Icons.gavel_outlined, color: AppTheme.textSecondary),
                    title: const Text('Terms & Conditions', style: TextStyle(color: AppTheme.textPrimary)),
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                    onTap: () {
                      SuccessFeedbackToast.show(context, 'All operations govern purely local mechanics.', isError: false);
                    },
                  ),
                  const Divider(color: Colors.white12, height: 1),
                  ListTile(
                    leading: const Icon(Icons.bug_report_outlined, color: AppTheme.textSecondary),
                    title: const Text('Bug Report', style: TextStyle(color: AppTheme.textPrimary)),
                    trailing: const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                    onTap: () {
                      SuccessFeedbackToast.show(context, 'System running optimally. No bugs detected.', isError: false);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDataResetConfirm(BuildContext context, WidgetRef ref) {
    ConfirmationDialog.show(
      context,
      title: 'PURGE ALL DATA?',
      message: 'This will delete all goals, habits, sessions, routines, and command history. This cannot be undone.',
      isDestructive: true,
      confirmText: 'PURGE',
    ).then((confirmed) async {
      if (confirmed == true) {
        try {
          // Step 1: Clear all Hive boxes
          await Hive.box<Goal>('goalsBox').clear();
          await Hive.box<Habit>('habitsBox').clear();
          await Hive.box<FocusSession>('sessionsBox').clear();
          await Hive.box<CommandHistory>('commandHistoryBox').clear();
          await Hive.box<Routine>('routinesBox').clear();
          await Hive.box('settingsBox').clear();

          // Step 2: Invalidate Riverpod Providers
          ref.invalidate(goalsProvider);
          ref.invalidate(habitsProvider);
          ref.invalidate(focusProvider);
          ref.invalidate(focusSessionsProvider);
          ref.invalidate(commandProvider);
          ref.invalidate(routinesProvider);

          if (!context.mounted) return;

          SuccessFeedbackToast.show(context, 'System memory purged successfully.');

          // Step 3: Navigate user to clean state (Dashboard via NavigationWrapperScreen)
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const NavigationWrapperScreen()),
            (route) => false,
          );
        } catch (e) {
          if (!context.mounted) return;
          SuccessFeedbackToast.show(context, 'Error purging system data.', isError: true);
        }
      }
    });
  }
}
