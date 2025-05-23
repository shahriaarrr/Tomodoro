import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tomodoro/providers/timer_provider.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerstate = ref.watch(TomodoroTimerProvider);
    final timerControllet = ref.read(TomodoroTimerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Tomodoro')),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${timerstate.remaining.inMinutes.toString().padLeft(2, '0')}:${(timerstate.remaining.inSeconds % 60).toString().padLeft(2, '0')}',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  timerstate.isRunning
                      ? timerControllet.pause
                      : timerControllet.start,
              child: Text(timerstate.isRunning ? 'Pause' : 'Start'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: timerControllet.reset,
              child: Text("Reset"),
            ),
          ],
        ),
      ),
    );
  }
}
