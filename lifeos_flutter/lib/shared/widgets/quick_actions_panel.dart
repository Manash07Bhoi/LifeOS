import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'glass_card.dart';

class QuickActionsPanel extends StatelessWidget {
  final VoidCallback onAddGoal;
  final VoidCallback onAddHabit;
  final VoidCallback onStartFocus;
  final VoidCallback onViewAnalytics;

  const QuickActionsPanel({
    super.key,
    required this.onAddGoal,
    required this.onAddHabit,
    required this.onStartFocus,
    required this.onViewAnalytics,
  });

  static void show(BuildContext context, {
    required VoidCallback onAddGoal,
    required VoidCallback onAddHabit,
    required VoidCallback onStartFocus,
    required VoidCallback onViewAnalytics,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => QuickActionsPanel(
        onAddGoal: () {
          Navigator.pop(ctx);
          onAddGoal();
        },
        onAddHabit: () {
          Navigator.pop(ctx);
          onAddHabit();
        },
        onStartFocus: () {
          Navigator.pop(ctx);
          onStartFocus();
        },
        onViewAnalytics: () {
          Navigator.pop(ctx);
          onViewAnalytics();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.background.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.textSecondary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _ActionCard(
                title: 'Add Goal',
                icon: Icons.track_changes,
                color: AppTheme.primaryPurple,
                onTap: onAddGoal,
              ),
              _ActionCard(
                title: 'Add Habit',
                icon: Icons.loop,
                color: AppTheme.neonCyan,
                onTap: onAddHabit,
              ),
              _ActionCard(
                title: 'Start Focus',
                icon: Icons.timer,
                color: AppTheme.neonPink,
                onTap: onStartFocus,
              ),
              _ActionCard(
                title: 'Analytics',
                icon: Icons.bar_chart,
                color: AppTheme.primaryPurple,
                onTap: onViewAnalytics,
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
