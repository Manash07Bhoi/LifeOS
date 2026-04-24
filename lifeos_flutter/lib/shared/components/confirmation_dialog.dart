import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/glow_button.dart';
import '../widgets/neon_text.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = 'CONFIRM',
    this.cancelText = 'CANCEL',
    this.onCancel,
    this.isDestructive = false,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'CONFIRM',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        isDestructive: isDestructive,
        onConfirm: () => Navigator.pop(ctx, true),
        onCancel: () => Navigator.pop(ctx, false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isDestructive
              ? AppTheme.neonPink.withValues(alpha: 0.5)
              : AppTheme.neonCyan.withValues(alpha: 0.5),
        ),
      ),
      title: NeonText(
        title,
        color: isDestructive ? AppTheme.neonPink : AppTheme.neonCyan,
        fontSize: 20,
        glow: false,
      ),
      content: Text(
        message,
        style: const TextStyle(color: AppTheme.textPrimary, height: 1.5),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.pop(context),
          child: Text(
            cancelText,
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
        ),
        GlowButton(
          text: confirmText,
          color: isDestructive ? AppTheme.neonPink : AppTheme.neonCyan,
          onPressed: onConfirm,
        ),
      ],
    );
  }
}
