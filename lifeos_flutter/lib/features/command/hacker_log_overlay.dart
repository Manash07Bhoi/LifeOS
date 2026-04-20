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

class _HackerLogOverlayState extends State<HackerLogOverlay> {
  final List<String> _displayedLogs = [];
  String _currentLog = '';
  int _logIndex = 0;
  int _charIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTyping() {
    if (_logIndex >= widget.logs.length) {
      widget.onComplete();
      return;
    }

    final targetStr = widget.logs[_logIndex];

    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_charIndex < targetStr.length) {
        setState(() {
          _currentLog += targetStr[_charIndex];
          _charIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          _displayedLogs.add(_currentLog);
          _currentLog = '';
          _logIndex++;
          _charIndex = 0;
        });

        // Pause before starting the next log line
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) _startTyping();
        });
      }
    });
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
          if (_currentLog.isNotEmpty || _logIndex < widget.logs.length)
            Row(
              children: [
                Text(
                  '> $_currentLog',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                  ),
                ),
                _BlinkingCursor(),
              ],
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
