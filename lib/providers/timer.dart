import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import 'package:hooks_riverpod/legacy.dart';

// Стейт таймера
class TimerState {
  final bool isRunning;
  final Duration elapsed;
  final Duration total;

  const TimerState({
    this.isRunning = false,
    this.elapsed = Duration.zero,
    this.total = const Duration(minutes: 25),
  });

  TimerState copyWith({
    bool? isRunning,
    Duration? elapsed,
    Duration? total,
  }) {
    return TimerState(
      isRunning: isRunning ?? this.isRunning,
      elapsed: elapsed ?? this.elapsed,
      total: total ?? this.total,
    );
  }
}

// Таймер нотифаер
class TimerNotifier extends StateNotifier<TimerState> {
  Timer? _timer;

  TimerNotifier() : super(const TimerState());

  void start() {
    if (state.isRunning) return;
    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final newElapsed = state.elapsed + const Duration(seconds: 1);
      if (newElapsed >= state.total) {
        stop();
      } else {
        state = state.copyWith(elapsed: newElapsed);
      }
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void stop() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false, elapsed: state.total);
  }

  void reset() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false, elapsed: Duration.zero);
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>(
  (ref) => TimerNotifier(),
);