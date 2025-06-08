import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tomodoro/models/timer.dart';
import 'package:tomodoro/pages/about.dart';
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
    // AnimationController drives the circular progress indicator
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(hours: 1),
    )..addListener(() {
      setState(() {}); // Rebuild on every tick
    });
    _progressController.repeat(); // Loop indefinitely
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Read timer state and controller from Riverpod
    final timerState = ref.watch(TomodoroTimerProvider);
    final timerController = ref.read(TomodoroTimerProvider.notifier);
    // Determine whether we are in dark mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Compute remaining minutes and seconds
    final minutes = timerState.remaining.inMinutes.remainder(60);
    final seconds = timerState.remaining.inSeconds.remainder(60);

    // Determine total seconds based on focus or break phase
    final totalSeconds =
        timerState.phase == TomodoroPhase.focus
            ? timerController.focusMinutes * 60
            : timerController.breakMinutes * 60;

    // Calculate end time for the countdown
    final DateTime endTime = DateTime.now().add(timerState.remaining);

    // Define the pages to display in the body
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
      const AboutPage(),
    ];

    // Titles for each page in the AppBar
    final List<String> pageTitles = ["Tomodoro", "Tasks", "Settings", "About"];

    return Scaffold(
      appBar: AppBar(title: Text(pageTitles[currentPageIndex])),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          // Slide + fade transition between pages
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
    // Extract theme colors for convenience
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final textColor = isDarkMode ? Colors.white : Colors.grey[800];
    final subtitleColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

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
                  // Circular progress drawn by CustomPainter
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      double progress = 0.0;
                      if (totalSeconds > 0) {
                        final remainingSeconds = timerState.remaining.inSeconds;
                        progress = remainingSeconds / totalSeconds;
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
                  // Remaining time text
                  Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: textColor,
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
                // Start / Pause button uses primary color
                TimerButton(
                  text: timerState.isRunning ? 'Pause' : 'Start',
                  color: primaryColor,
                  onPressed:
                      timerState.isRunning
                          ? timerController.pause
                          : timerController.start,
                ),
                const SizedBox(width: 20),
                // Reset button uses secondary color
                TimerButton(
                  text: 'Reset',
                  color: secondaryColor,
                  onPressed: timerController.reset,
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Display current phase (Focus / Break)
            Text(
              "Current Phase: ${timerState.phase == TomodoroPhase.focus ? "Focus" : "Break"}",
              style: TextStyle(color: subtitleColor, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
