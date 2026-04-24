import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SuccessFeedbackToast {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final color = isError ? AppTheme.neonPink : AppTheme.neonCyan;
    final icon = isError ? Icons.error_outline : Icons.check_circle_outline;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.surfaceElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: color.withValues(alpha: 0.5), width: 1),
        ),
        margin: const EdgeInsets.all(24),
        elevation: 8,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
