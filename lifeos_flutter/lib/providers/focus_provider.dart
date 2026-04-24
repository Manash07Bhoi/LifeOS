import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/focus_session.dart';

enum FocusState { idle, running, paused, completed }

class FocusTimerState {
  final int initialMinutes;
  final int remainingSeconds;
  final FocusState status;
  final String? activeGoalId;

  FocusTimerState({
    this.initialMinutes = 25,
    this.remainingSeconds = 25 * 60,
    this.status = FocusState.idle,
    this.activeGoalId,
  });

  FocusTimerState copyWith({
    int? initialMinutes,
    int? remainingSeconds,
    FocusState? status,
    String? activeGoalId,
  }) {
    return FocusTimerState(
      initialMinutes: initialMinutes ?? this.initialMinutes,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
      activeGoalId: activeGoalId ?? this.activeGoalId,
    );
  }
}

class FocusProvider extends StateNotifier<FocusTimerState>
    with WidgetsBindingObserver {
  Timer? _timer;
  DateTime? _sessionStartTime;
  DateTime? _targetEndTime;
  int _pausedRemainingSeconds = 0;
  final Box<FocusSession> _box;

  FocusProvider(this._box) : super(FocusTimerState()) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        this.state.status == FocusState.running) {
      _resyncTimer();
    } else if (state == AppLifecycleState.paused &&
        this.state.status == FocusState.running) {
      // Timer continues in background via _targetEndTime, but we pause the UI tick
      _timer?.cancel();
    }
  }

  void _resyncTimer() {
    if (_targetEndTime == null || state.status != FocusState.running) return;

    final now = DateTime.now();
    final remaining = _targetEndTime!.difference(now).inSeconds;

    if (remaining <= 0) {
      _completeSession();
    } else {
      state = state.copyWith(remainingSeconds: remaining);
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (state.remainingSeconds > 0) {
          state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
        } else {
          _completeSession();
        }
      });
    }
  }

  void setDuration(int minutes) {
    if (state.status == FocusState.idle) {
      state = state.copyWith(
        initialMinutes: minutes,
        remainingSeconds: minutes * 60,
      );
    }
  }

  void setGoalId(String goalId) {
    state = state.copyWith(activeGoalId: goalId);
  }

  void startTimer() {
    if (state.status == FocusState.idle || state.status == FocusState.paused) {
      if (state.status == FocusState.idle) {
        _sessionStartTime = DateTime.now();
        _targetEndTime = _sessionStartTime!.add(
          Duration(minutes: state.initialMinutes),
        );
      } else if (state.status == FocusState.paused) {
        _targetEndTime = DateTime.now().add(
          Duration(seconds: _pausedRemainingSeconds),
        );
      }

      state = state.copyWith(status: FocusState.running);

      _resyncTimer();
    }
  }

  void pauseTimer() {
    if (state.status == FocusState.running) {
      _timer?.cancel();
      _pausedRemainingSeconds = state.remainingSeconds;
      state = state.copyWith(status: FocusState.paused);
    }
  }

  void _completeSession() {
    if (state.status == FocusState.completed) return; // Prevent double trigger

    _timer?.cancel();
    state = state.copyWith(status: FocusState.completed, remainingSeconds: 0);
    _saveSession();
  }

  void cancelSession() {
    _timer?.cancel();
    _targetEndTime = null;
    state = FocusTimerState();
  }

  void resetTimer() {
    _timer?.cancel();
    _targetEndTime = null;
    state = FocusTimerState();
  }

  void _saveSession() {
    if (_sessionStartTime != null) {
      final session = FocusSession(
        durationMinutes: state.initialMinutes,
        startTime: _sessionStartTime!,
        endTime: DateTime.now(),
        relatedGoalId: state.activeGoalId,
      );
      _box.add(session);
    }
  }
}

final focusProvider = StateNotifierProvider<FocusProvider, FocusTimerState>((
  ref,
) {
  final box = Hive.box<FocusSession>('sessionsBox');
  return FocusProvider(box);
});

// A provider simply to watch focus sessions history
final focusSessionsProvider = Provider<List<FocusSession>>((ref) {
  final box = Hive.box<FocusSession>('sessionsBox');
  return box.values.toList();
});
