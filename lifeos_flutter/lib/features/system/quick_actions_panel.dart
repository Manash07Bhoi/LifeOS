import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/glass_card.dart';

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

  static void show(
    BuildContext context, {
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

class _ActionCard extends StatefulWidget {
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
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.title,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _controller.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _controller.reverse();
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: _isPressed
                      ? [
                          BoxShadow(
                            color: widget.color.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.icon, color: widget.color, size: 32),
                      const SizedBox(height: 12),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
