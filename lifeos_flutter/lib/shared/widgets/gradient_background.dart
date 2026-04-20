import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class GradientBackground extends StatefulWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                -1.0 + (_controller.value * 2),
                -1.0 + (_controller.value * 0.5)
              ),
              end: Alignment(
                1.0 - (_controller.value * 2),
                1.0 - (_controller.value * 0.5)
              ),
              colors: [
                AppTheme.background,
                AppTheme.background,
                AppTheme.primaryPurple.withValues(alpha: 0.03),
                AppTheme.neonCyan.withValues(alpha: 0.02),
                AppTheme.background,
              ],
              stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
