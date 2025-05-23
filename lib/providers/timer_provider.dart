import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tomodoro/models/timer.dart';

final TomodoroTimerProvider =
    StateNotifierProvider<TomodoroTimerController, TomodoroTimerState>(
      (ref) => TomodoroTimerController(),
    );

class TomodoroTimerController extends StateNotifier<TomodoroTimerState> {
  TomodoroTimerController()
    : super(
        TomodoroTimerState(
          remaining: const Duration(minutes: 25),
          isRunning: false,
          phase: TomodoroPhase.focus,
        ),
      );
  Timer? _timer;

  void start() {
    if (state.isRunning) return;

    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remaining.inSeconds > 0) {
        state = state.copyWith(
          remaining: Duration(seconds: state.remaining.inSeconds - 1),
        );
      } else {
        _switchPhase();
      }
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    state = state.copyWith(
      remaining: _initialDuration(),
      isRunning: false,
      phase: state.phase,
    );
  }

  void _switchPhase() {
    _timer?.cancel();
    final nextPhase =
        state.phase == TomodoroPhase.focus
            ? TomodoroPhase.breaks
            : TomodoroPhase.focus;
    final nextDuration = _initialDuration(phase: nextPhase);

    state = TomodoroTimerState(
      remaining: nextDuration,
      isRunning: false,
      phase: nextPhase,
    );
  }

  Duration _initialDuration({TomodoroPhase? phase}) {
    final currentphase = phase ?? state.phase;

    return currentphase == TomodoroPhase.focus
        ? const Duration(minutes: 25)
        : const Duration(minutes: 5);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
