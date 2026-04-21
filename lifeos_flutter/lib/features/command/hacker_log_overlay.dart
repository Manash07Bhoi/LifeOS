import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'dart:async';

class HackerLogOverlay extends StatefulWidget {
  final List<String> logs;
  final VoidCallback onComplete;

  const HackerLogOverlay({super.key, required this.logs, required this.onComplete});

  @override
  State<HackerLogOverlay> createState() => _HackerLogOverlayState();
}

<<<<<<< Updated upstream
class _HackerLogOverlayState extends State<HackerLogOverlay> with TickerProviderStateMixin {
  final List<String> _displayedLogs = [];
  int _logIndex = 0;
  late AnimationController _typingController;
  late Animation<int> _charCount;
  Timer? _pauseTimer;
=======
class _HackerLogOverlayState extends State<HackerLogOverlay> with SingleTickerProviderStateMixin {
  final List<String> _displayedLogs = [];
  int _logIndex = 0;
  late AnimationController _typingController;
  late Animation<int> _typingAnimation;
>>>>>>> Stashed changes

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(vsync: this);
<<<<<<< Updated upstream
    _typingController.addStatusListener(_handleAnimationStatus);
=======
    _typingController.addStatusListener(_onTypingStatusChanged);
>>>>>>> Stashed changes
    _startTyping();
  }

  @override
  void dispose() {
<<<<<<< Updated upstream
    _pauseTimer?.cancel();
=======
    _typingController.removeStatusListener(_onTypingStatusChanged);
>>>>>>> Stashed changes
    _typingController.dispose();
    super.dispose();
  }

<<<<<<< Updated upstream
  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _displayedLogs.add(widget.logs[_logIndex]);
        _logIndex++;
        // Reset immediately to avoid flashing the full next text
        // string during the 400ms pause delay.
        _typingController.value = 0.0;
      });
      _pauseTimer = Timer(const Duration(milliseconds: 400), () {
        if (mounted) _startTyping();
      });
=======
  void _onTypingStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (_logIndex < widget.logs.length) {
        setState(() {
          _displayedLogs.add(widget.logs[_logIndex]);
          _logIndex++;
          // Reset the controller value to 0 to avoid RangeError in the AnimatedBuilder
          // when `_logIndex` increments but the new animation hasn't been configured yet.
          _typingController.value = 0.0;
        });

        // Pause before starting the next log line
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) _startTyping();
        });
      }
>>>>>>> Stashed changes
    }
  }

  void _startTyping() {
    if (_logIndex >= widget.logs.length) {
      widget.onComplete();
      return;
    }

    final targetStr = widget.logs[_logIndex];
<<<<<<< Updated upstream
    // Reset explicitly to 0.0 before creating a new tween to avoid RangeError
    // during AnimatedBuilder's build phase with a shorter string.
    _typingController.value = 0.0;
    _typingController.duration = Duration(milliseconds: targetStr.length * 30);
    _charCount = StepTween(begin: 0, end: targetStr.length).animate(_typingController);
    _typingController.forward();
=======
    _typingController.duration = Duration(milliseconds: targetStr.length * 30);
    _typingAnimation = StepTween(begin: 0, end: targetStr.length).animate(_typingController);

    _typingController.forward(from: 0.0);
>>>>>>> Stashed changes
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.background.withValues(alpha: 0.98),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var log in _displayedLogs)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                '> $log',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: AppTheme.neonCyan,
                  fontSize: 14,
                ),
              ),
            ),
          if (_logIndex < widget.logs.length)
<<<<<<< Updated upstream
            Row(
              children: [
                AnimatedBuilder(
                  animation: _typingController,
                  builder: (context, child) {
                    final currentLog = widget.logs[_logIndex];
                    final displayedText = currentLog.substring(0, _charCount.value.clamp(0, currentLog.length));
                    return Text(
                      '> $displayedText',
=======
            AnimatedBuilder(
              animation: _typingAnimation,
              builder: (context, child) {
                final currentTargetStr = widget.logs[_logIndex];
                final visibleText = currentTargetStr.substring(0, _typingAnimation.value);
                return Row(
                  children: [
                    Text(
                      '> $visibleText',
>>>>>>> Stashed changes
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                      ),
<<<<<<< Updated upstream
                    );
                  },
                ),
                _BlinkingCursor(),
              ],
=======
                    ),
                    _BlinkingCursor(),
                  ],
                );
              },
>>>>>>> Stashed changes
            ),
        ],
      ),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 8,
        height: 16,
        color: AppTheme.neonCyan,
        margin: const EdgeInsets.only(left: 4),
      ),
    );
  }
}
