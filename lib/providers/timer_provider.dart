import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tomodoro/core/data/cache/cache_provider.dart';
import 'package:tomodoro/models/timer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

final tomodoroTimerProvider =
    StateNotifierProvider<TomodoroTimerController, TomodoroTimerState>(
      (ref) => TomodoroTimerController(),
    );

class TomodoroTimerController extends StateNotifier<TomodoroTimerState> {

  TomodoroTimerController()
    : super(
        TomodoroTimerState(
          remaining: Duration(minutes: CacheProvider().getFocus),
          isRunning: false,
          phase: TomodoroPhase.focus,
        ),
      ) {
    _initializeTimer();
  }

  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int focusMinutes = 0;
  int breakMinutes = 0;
  int? remainingSeconds;
  DateTime? _startTime;
  Duration _totalDuration = Duration.zero;

  void setDurations({required int focus, required int breaks}) async {
    await CacheProvider().setFocus(focus);
    await CacheProvider().setBreak(breaks);
    focusMinutes = focus;
    breakMinutes = breaks;
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
      final newRemaining = _totalDuration - elapsed;
      state = state.copyWith(
        isRunning: false,
        remaining: newRemaining
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

  Future<void> _initializeTimer() async {
    focusMinutes = CacheProvider().getFocus;
    breakMinutes = CacheProvider().getBreak;
  }

  @override
  void dispose() {
    pause();
    super.dispose();
  }
}
