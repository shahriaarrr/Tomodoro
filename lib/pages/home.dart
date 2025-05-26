import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tomodoro/models/timer.dart';
import 'package:tomodoro/pages/tasks.dart';
import 'package:tomodoro/pages/settings.dart';
import 'dart:math';

import 'package:tomodoro/providers/timer_provider.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(TomodoroTimerProvider);
    final timerController = ref.read(TomodoroTimerProvider.notifier);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final minutes = timerState.remaining.inMinutes.remainder(60);
    final seconds = timerState.remaining.inSeconds.remainder(60);

    final progress =
        timerState.remaining.inSeconds /
        (timerState.phase == TomodoroPhase.focus ? 25 * 60 : 5 * 60);

    final List<Widget> pages = [
      _buildTimerPage(
        timerState,
        timerController,
        minutes,
        seconds,
        progress,
        isDarkMode,
      ),
      const TasksPage(),
      const SettingsPage(),
    ];

    final List<String> pageTitles = ["Tomodoro", "Tasks", "Settings"];

    return Scaffold(
      appBar: AppBar(title: Text(pageTitles[currentPageIndex])),
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor:
            isDarkMode ? const Color(0xFF2A2A3E) : Colors.grey[100],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.timer, color: const Color(0xFF6C63FF)),
            icon: Icon(
              Icons.timer_outlined,
              color: isDarkMode ? Colors.grey : Colors.grey[600],
            ),
            label: 'Timer',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.task_alt, color: const Color(0xFF6C63FF)),
            icon: Icon(
              Icons.task_alt_outlined,
              color: isDarkMode ? Colors.grey : Colors.grey[600],
            ),
            label: 'Tasks',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings, color: const Color(0xFF6C63FF)),
            icon: Icon(
              Icons.settings_outlined,
              color: isDarkMode ? Colors.grey : Colors.grey[600],
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildTimerPage(
    timerState,
    timerController,
    int minutes,
    int seconds,
    double progress,
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
                  CustomPaint(
                    size: const Size(200, 200),
                    painter: _CirclePainter(
                      progress: progress,
                      isDarkMode: isDarkMode,
                    ),
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
                _TimerButton(
                  text: timerState.isRunning ? 'Pause' : 'Start',
                  color: const Color(0xFF6C63FF),
                  onPressed:
                      timerState.isRunning
                          ? timerController.pause
                          : timerController.start,
                ),
                const SizedBox(width: 20),
                _TimerButton(
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

class _TimerButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _TimerButton({
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double progress;
  final bool isDarkMode;

  _CirclePainter({required this.progress, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final baseCircle =
        Paint()
          ..strokeWidth = 12
          ..color = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300
          ..style = PaintingStyle.stroke;

    final progressCircle =
        Paint()
          ..strokeWidth = 12
          ..color = const Color(0xFF00A693)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawCircle(center, radius, baseCircle);

    final angle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      -angle,
      false,
      progressCircle,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.isDarkMode != isDarkMode;
}
