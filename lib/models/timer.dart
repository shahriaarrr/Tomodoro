enum TomodoroPhase { focus, breaks }

class TomodoroTimerState {
  final Duration remaining;
  final bool isRunning;
  final TomodoroPhase phase;

  TomodoroTimerState({
    required this.remaining,
    required this.isRunning,
    required this.phase,
  });

  TomodoroTimerState copyWith({
    Duration? remaining,
    bool? isRunning,
    TomodoroPhase? phase,
  }) {
    return TomodoroTimerState(
      remaining: remaining ?? this.remaining,
      isRunning: isRunning ?? this.isRunning,
      phase: phase ?? this.phase,
    );
  }
}
