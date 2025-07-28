package com.example.tomodoro

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "tomodoro/live_notification"


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            var actionHandled = true
            val intent = Intent(this, TomodoroService::class.java)
            when (call.method) {
                "startTimer" -> {
                    val duration = call.argument<Int>(ARG_DURATION) ?: 0
                    intent.putExtra(ARG_DURATION, duration)
                    intent.action = ACTION_START_TIMER
                }
                "stopTimer" -> {
                    intent.action = ACTION_STOP_TIMER
                }
                "resumeTimer" -> {
                    intent.action = ACTION_RESUME_TIMER
                }
                "pauseTimer" -> {
                    intent.action = ACTION_PAUSE_TIMER
                }
                else -> {
                    result.notImplemented()
                    actionHandled = false
                }
            }
            if (actionHandled) {
                startService(intent)
                result.success(null)
            }
        }
    }



    companion object {
        const val ACTION_START_TIMER = "START_TIMER"
        const val ACTION_STOP_TIMER = "STOP_TIMER"
        const val ACTION_RESUME_TIMER = "RESUME_TIMER"
        const val ACTION_PAUSE_TIMER = "PAUSE_TIMER"
        const val ARG_DURATION = "duration"
    }

}
