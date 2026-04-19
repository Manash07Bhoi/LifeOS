import 'dart:async';
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

class FocusProvider extends StateNotifier<FocusTimerState> {
  Timer? _timer;
  DateTime? _sessionStartTime;
  final Box<FocusSession> _box;

  FocusProvider(this._box) : super(FocusTimerState());

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
      }
      state = state.copyWith(status: FocusState.running);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (state.remainingSeconds > 0) {
          state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
        } else {
          _completeSession();
        }
      });
    }
  }

  void pauseTimer() {
    if (state.status == FocusState.running) {
      _timer?.cancel();
      state = state.copyWith(status: FocusState.paused);
    }
  }

  void _completeSession() {
    _timer?.cancel();
    state = state.copyWith(status: FocusState.completed);
    _saveSession();
  }

  void cancelSession() {
      _timer?.cancel();
      state = FocusTimerState();
  }

  void resetTimer() {
    _timer?.cancel();
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

final focusProvider = StateNotifierProvider<FocusProvider, FocusTimerState>((ref) {
  final box = Hive.box<FocusSession>('sessionsBox');
  return FocusProvider(box);
});

// A provider simply to watch focus sessions history
final focusSessionsProvider = Provider<List<FocusSession>>((ref) {
  final box = Hive.box<FocusSession>('sessionsBox');
  return box.values.toList();
});
