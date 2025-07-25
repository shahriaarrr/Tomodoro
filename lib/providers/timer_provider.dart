import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomodoro/models/timer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

final tomodoroTimerProvider =
    StateNotifierProvider<TomodoroTimerController, TomodoroTimerState>(
      (ref) => TomodoroTimerController(),
    );

class TomodoroTimerController extends StateNotifier<TomodoroTimerState> {
  static const _timerKey = "app-timer";

  TomodoroTimerController()
    : super(
        TomodoroTimerState(
          remaining: const Duration(minutes: 25),
          isRunning: false,
          phase: TomodoroPhase.focus,
        ),
      ) {
    _initializeTimer();
  }

  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int focusMinutes = 25;
  int breakMinutes = 5;
  int? remainingSeconds;
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
        clearDuration();
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
      saveDuration(newRemaining);
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
    clearDuration();
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

  Future<void> saveDuration(Duration duration) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_timerKey, duration.inMilliseconds);
  }

  Future<Duration?> loadDuration() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_timerKey);
    if(ms != null) {
      return Duration(milliseconds: ms);
    }
    return null;
  }

  Future<void> clearDuration() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_timerKey);
    remainingSeconds = null;
  }

  Future<void> _initializeTimer() async {
    final loadedDuration = await loadDuration();

    if(loadedDuration != null) {
      state = state.copyWith(remaining: loadedDuration);
    }
  }

  Future<void> loadTimerValue() async {
    final loadedDuration = await loadDuration();
    if(loadedDuration != null) {
       remainingSeconds = loadedDuration.inSeconds;
    }
  }

  @override
  void dispose() {
    pause();
    super.dispose();
  }
}
