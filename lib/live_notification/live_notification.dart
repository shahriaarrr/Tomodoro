import 'package:flutter/services.dart';

class LiveNotification {
  static const _instance = LiveNotification._();
  const LiveNotification._();

  factory LiveNotification() => _instance;

  static const platform = MethodChannel('tomodoro/live_notification');

  Future<void> startTimer(int durationInSeconds) async {
    await platform.invokeMethod('startTimer', {'duration': durationInSeconds});
  }

  Future<void> pauseTimer() async {
    await platform.invokeMethod('pauseTimer');
  }

  Future<void> resumeTimer() async {
    await platform.invokeMethod('resumeTimer');
  }

  Future<void> stopTimer() async {
    await platform.invokeMethod('stopTimer');
  }
}
