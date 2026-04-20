import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/neon_text.dart';
import '../../providers/goals_provider.dart';
import '../../providers/habits_provider.dart';
import '../../providers/focus_provider.dart';

import '../../shared/widgets/loading_skeleton.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(goalsProvider);
    final habits = ref.watch(habitsProvider);
    final sessions = ref.watch(focusSessionsProvider);

    int totalFocusMinutes = sessions.fold(0, (sum, session) => sum + session.durationMinutes);
    int goalsCompleted = goals.where((g) => g.progress >= 1.0).length;
    int maxStreak = habits.isEmpty ? 0 : habits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const NeonText('USER PROFILE', color: AppTheme.textPrimary, glow: false),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.surfaceElevated,
                      border: Border.all(color: AppTheme.primaryPurple, width: 3),
                    ),
                    child: const Icon(Icons.person_outline, size: 64, color: AppTheme.primaryPurple),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const NeonText('OPERATOR', color: AppTheme.textPrimary, fontSize: 28),
              const SizedBox(height: 8),
              const Text('STATUS: ONLINE', style: TextStyle(color: AppTheme.neonCyan, letterSpacing: 2, fontWeight: FontWeight.bold)),
              const SizedBox(height: 48),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('LIFETIME METRICS', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1.5)),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                 const LoadingSkeleton(width: double.infinity, height: 250)
              else
                GlassCard(
                  child: Column(
                    children: [
                      _StatRow(icon: Icons.timer, color: AppTheme.neonCyan, label: 'Total Focus Time', value: '${totalFocusMinutes}m'),
                      const Divider(color: Colors.white12, height: 32),
                      _StatRow(icon: Icons.track_changes, color: AppTheme.primaryPurple, label: 'Goals Completed', value: '$goalsCompleted'),
                      const Divider(color: Colors.white12, height: 32),
                      _StatRow(icon: Icons.local_fire_department, color: AppTheme.neonPink, label: 'Max Habit Streak', value: '$maxStreak days'),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
        ),
        Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
