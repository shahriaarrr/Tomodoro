import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tomodoro/models/timer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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
  final AudioPlayer _audioPlayer = AudioPlayer();

  int focusMinutes = 25;
  int breakMinutes = 5;

  DateTime? _startTime;
  Duration _totalDuration = Duration.zero;

  void setDurations({required int focus, required int breaks}) {
    focusMinutes = focus;
    breakMinutes = breaks;
    // Reset timer to new durations if needed
    state = state.copyWith(
      remaining: _initialDuration(),
      isRunning: false,
      phase: state.phase,
    );
  }

  void start() {
    if (state.isRunning) return;
    _startTime = DateTime.now();
    _totalDuration = state.remaining;
    state = state.copyWith(isRunning: true);

    WakelockPlus.enable();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final elapsed = DateTime.now().difference(_startTime!);
      final remaining = _totalDuration - elapsed;
      if (remaining > Duration.zero) {
        state = state.copyWith(remaining: remaining);
      } else {
        _switchPhase();
      }
    });
  }

  void pause() {
    _timer?.cancel();
    if (_startTime != null) {
      final elapsed = DateTime.now().difference(_startTime!);
      state = state.copyWith(
        isRunning: false,
        remaining: _totalDuration - elapsed,
      );
    }
    _startTime = null;
    WakelockPlus.disable();
  }

  void reset() {
    _timer?.cancel();
    _startTime = null;
    state = state.copyWith(
      remaining: _initialDuration(),
      isRunning: false,
      phase: state.phase,
    );
    WakelockPlus.disable();
  }

  void _switchPhase() async {
    _timer?.cancel();
    await _audioPlayer.play(AssetSource('audios/ding.mp3'));

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
    WakelockPlus.disable();
  }

  Duration _initialDuration({TomodoroPhase? phase}) {
    final currentphase = phase ?? state.phase;

    return currentphase == TomodoroPhase.focus
        ? Duration(minutes: focusMinutes)
        : Duration(minutes: breakMinutes);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
