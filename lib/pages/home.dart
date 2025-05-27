import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tomodoro/models/timer.dart';
import 'package:tomodoro/pages/tasks.dart';
import 'package:tomodoro/pages/settings.dart';

import 'package:tomodoro/providers/timer_provider.dart';
import 'package:tomodoro/widgets/TimerButton.dart';
import 'package:tomodoro/widgets/circlePainter.dart';
import 'package:tomodoro/widgets/main_navigation_bar.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage>
    with SingleTickerProviderStateMixin {
  int currentPageIndex = 0;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(hours: 1),
    )..addListener(() {
      setState(() {});
    });
    _progressController.repeat();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(TomodoroTimerProvider);
    final timerController = ref.read(TomodoroTimerProvider.notifier);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final minutes = timerState.remaining.inMinutes.remainder(60);
    final seconds = timerState.remaining.inSeconds.remainder(60);

    final totalSeconds =
        timerState.phase == TomodoroPhase.focus
            ? timerController.focusMinutes * 60
            : timerController.breakMinutes * 60;

    final DateTime endTime = DateTime.now().add(timerState.remaining);

    final List<Widget> pages = [
      _buildTimerPage(
        timerState,
        timerController,
        minutes,
        seconds,
        totalSeconds,
        endTime,
        isDarkMode,
      ),
      const TasksPage(),
      const SettingsPage(),
    ];

    final List<String> pageTitles = ["Tomodoro", "Tasks", "Settings"];

    return Scaffold(
      appBar: AppBar(title: Text(pageTitles[currentPageIndex])),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(0.1, 0),
            end: Offset.zero,
          ).animate(animation);
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: offsetAnimation, child: child),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(currentPageIndex),
          child: pages[currentPageIndex],
        ),
      ),
      bottomNavigationBar: MainNavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        isDarkMode: isDarkMode,
      ),
    );
  }

  Widget _buildTimerPage(
    timerState,
    timerController,
    int minutes,
    int seconds,
    int totalSeconds,
    DateTime endTime,
    bool isDarkMode,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      double progress = 0.0;
                      if (totalSeconds > 0) {
                        final now = DateTime.now();
                        final remaining =
                            endTime.difference(now).inMilliseconds / 1000.0;
                        progress = remaining / totalSeconds;
                        if (progress < 0) progress = 0;
                        if (progress > 1) progress = 1;
                      }
                      return CustomPaint(
                        size: const Size(200, 200),
                        painter: CirclePainter(
                          progress: progress,
                          isDarkMode: isDarkMode,
                        ),
                      );
                    },
                  ),
                  Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.grey[800],
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimerButton(
                  text: timerState.isRunning ? 'Pause' : 'Start',
                  color: const Color(0xFF6C63FF),
                  onPressed:
                      timerState.isRunning
                          ? timerController.pause
                          : timerController.start,
                ),
                const SizedBox(width: 20),
                TimerButton(
                  text: 'Reset',
                  color: const Color(0xFFEF476F),
                  onPressed: timerController.reset,
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              "Current Phase: ${timerState.phase == TomodoroPhase.focus ? "Focus" : "Break"}",
              style: TextStyle(
                color: isDarkMode ? Colors.grey : Colors.grey[600],
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
