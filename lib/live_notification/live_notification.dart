import 'package:flutter/services.dart';

class LiveNotification {
  static const _instance = LiveNotification._();
  const LiveNotification._();

  factory LiveNotification() => _instance;

  static const platform = MethodChannel('pomodoro/live_notification');

  Future<void> startLiveNotification(int durationInSeconds) async {
    await platform.invokeMethod('startLiveActivity', {
      'duration': durationInSeconds,
    });
  }

  Future<void> updateLiveNotification(int remainingSeconds) async {
    await platform.invokeMethod('updateLiveActivity', {
      'remaining': remainingSeconds,
    });
  }

  Future<void> stopLiveNotification() async {
    await platform.invokeMethod('stopLiveActivity');
  }
}
