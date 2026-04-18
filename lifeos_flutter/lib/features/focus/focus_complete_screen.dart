import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/glow_button.dart';
import '../../shared/widgets/neon_text.dart';
import '../../providers/focus_provider.dart';

class FocusCompleteScreen extends ConsumerWidget {
  const FocusCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.neonCyan.withValues(alpha: 0.1),
                    border: Border.all(color: AppTheme.neonCyan.withValues(alpha: 0.5), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.neonCyan.withValues(alpha: 0.3),
                        blurRadius: 40,
                        spreadRadius: 10,
                      )
                    ]
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 80,
                    color: AppTheme.neonCyan,
                  ),
                ),
                const SizedBox(height: 48),
                const NeonText(
                  'PROTOCOL COMPLETE',
                  color: AppTheme.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Focus session successfully logged to local storage. Synaptic efficiency optimal.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 64),
                SizedBox(
                  width: double.infinity,
                  child: GlowButton(
                    text: 'RETURN TO DASHBOARD',
                    color: AppTheme.neonCyan,
                    onPressed: () {
                      ref.read(focusProvider.notifier).resetTimer();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
