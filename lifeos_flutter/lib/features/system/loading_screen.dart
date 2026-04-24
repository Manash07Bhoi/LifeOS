import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/neon_text.dart';

class LoadingScreen extends StatelessWidget {
  final String message;

  const LoadingScreen({super.key, this.message = 'SYSTEM PROCESSING...'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppTheme.neonCyan),
            const SizedBox(height: 24),
            NeonText(
              message,
              color: AppTheme.textSecondary,
              fontSize: 14,
              glow: false,
            ),
          ],
        ),
      ),
    );
  }
}
