import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/glow_button.dart';
import '../../shared/widgets/neon_text.dart';
import '../../shared/components/confirmation_dialog.dart';
import '../../providers/focus_provider.dart';
import 'focus_complete_screen.dart';

class FocusScreen extends ConsumerWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusState = ref.watch(focusProvider);

    ref.listen(focusProvider, (previous, next) {
      if (previous?.status != FocusState.completed && next.status == FocusState.completed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const FocusCompleteScreen()),
            );
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (focusState.status == FocusState.running || focusState.status == FocusState.paused) {
              ConfirmationDialog.show(
                context,
                title: 'ABORT PROTOCOL?',
                message: 'Exiting now will discard this session. Time tracked will not be saved.',
                isDestructive: true,
                confirmText: 'ABORT',
              ).then((confirmed) {
                if (confirmed == true) {
                  ref.read(focusProvider.notifier).cancelSession();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const NeonText('DEEP FOCUS', color: AppTheme.textPrimary, glow: false),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TimerDisplay(
                remainingSeconds: focusState.remainingSeconds,
                isRunning: focusState.status == FocusState.running,
              ),
              const SizedBox(height: 64),
              if (focusState.status == FocusState.idle) ...[
                _FocusConfig(
                  initialMinutes: focusState.initialMinutes,
                  onDurationSelected: (minutes) =>
                      ref.read(focusProvider.notifier).setDuration(minutes),
                ),
                const SizedBox(height: 48),
              ],
              _FocusControls(
                status: focusState.status,
                onStart: () => ref.read(focusProvider.notifier).startTimer(),
                onPause: () => ref.read(focusProvider.notifier).pauseTimer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimerDisplay extends StatelessWidget {
  final int remainingSeconds;
  final bool isRunning;

  const _TimerDisplay({
    required this.remainingSeconds,
    required this.isRunning,
  });

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.surfaceElevated,
        border: Border.all(
          color: isRunning
              ? AppTheme.primaryPurple
              : AppTheme.textSecondary.withValues(alpha: 0.3),
          width: 4,
        ),
        boxShadow: isRunning
            ? [
                BoxShadow(
                  color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                  blurRadius: 40,
                  spreadRadius: 10,
                )
              ]
            : null,
      ),
      child: Center(
        child: Text(
          _formatTime(remainingSeconds),
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: isRunning ? AppTheme.primaryPurple : AppTheme.textPrimary,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class _FocusConfig extends StatelessWidget {
  final int initialMinutes;
  final ValueChanged<int> onDurationSelected;

  const _FocusConfig({
    required this.initialMinutes,
    required this.onDurationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _DurationButton(
          minutes: 15,
          isActive: initialMinutes == 15,
          onTap: () => onDurationSelected(15),
        ),
        const SizedBox(width: 16),
        _DurationButton(
          minutes: 25,
          isActive: initialMinutes == 25,
          onTap: () => onDurationSelected(25),
        ),
        const SizedBox(width: 16),
        _DurationButton(
          minutes: 50,
          isActive: initialMinutes == 50,
          onTap: () => onDurationSelected(50),
        ),
      ],
    );
  }
}

class _FocusControls extends StatelessWidget {
  final FocusState status;
  final VoidCallback onStart;
  final VoidCallback onPause;

  const _FocusControls({
    required this.status,
    required this.onStart,
    required this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    if (status == FocusState.idle) {
      return SizedBox(
        width: 200,
        child: GlowButton(
          text: 'INITIATE',
          color: AppTheme.primaryPurple,
          onPressed: onStart,
        ),
      );
    }

    if (status == FocusState.running) {
      return SizedBox(
        width: 200,
        child: GlowButton(
          text: 'PAUSE',
          color: AppTheme.neonPink,
          onPressed: onPause,
        ),
      );
    }

    if (status == FocusState.paused) {
      return SizedBox(
        width: 200,
        child: GlowButton(
          text: 'RESUME',
          color: AppTheme.neonCyan,
          onPressed: onStart,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _DurationButton extends StatelessWidget {
  final int minutes;
  final bool isActive;
  final VoidCallback onTap;

  const _DurationButton({
    required this.minutes,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryPurple.withValues(alpha: 0.2) : Colors.transparent,
          border: Border.all(
            color: isActive ? AppTheme.primaryPurple : AppTheme.textSecondary.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          '$minutes',
          style: TextStyle(
            color: isActive ? AppTheme.primaryPurple : AppTheme.textSecondary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
