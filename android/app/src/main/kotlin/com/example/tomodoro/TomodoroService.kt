package com.example.tomodoro

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.CountDownTimer
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat

class TomodoroService : Service() {

    private val NOTIFICATION_ID = 1
    private val CHANNEL_ID = "tomodoro_channel"

    private var countDownTimer: CountDownTimer? = null
    private var timeLeftInMillis: Long = 25 * 60 * 1000


    override fun onCreate() {
        super.onCreate()
        Log.d("TomodoroService", "Service created")
    }
    fun startTimer() {
        countDownTimer = object : CountDownTimer(timeLeftInMillis, 1000) {
            override fun onTick(millisUntilFinished: Long) {
                timeLeftInMillis = millisUntilFinished
                updateNotification("Time left: ${formatTime(millisUntilFinished.toInt() / 1000)}")
            }

            override fun onFinish() {
                // Timer finished logic
                stopSelf()
            }
        }.start()
    }

    fun pauseTimer() {
        countDownTimer?.cancel()
    }

    fun resumeTimer() {
        startTimer() // resumes with the last value of `timeLeftInMillis`
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            "START_TIMER" -> {
                try {
                    createNotificationChannel()
                    timeLeftInMillis = (intent.getIntExtra("duration", 0) * 1000).toLong()
                    startForeground(NOTIFICATION_ID, createNotification("Pomodoro started"))
                    startTimer()
                } catch (e: Exception) {
                    stopSelf()
                    return START_NOT_STICKY
                }
            }
            "PAUSE_TIMER" -> pauseTimer()
            "RESUME_TIMER" -> resumeTimer()
            "STOP_TIMER" -> stopSelf()
        }
        return START_STICKY
    }
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel =
                NotificationChannel(CHANNEL_ID, "Pomodoro", NotificationManager.IMPORTANCE_HIGH)
            channel.setSound(null,null)
            channel.enableVibration(false)
            channel.lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            getSystemService(NotificationManager::class.java).createNotificationChannel(channel)
        }
    }
    private fun createNotification(content: String): Notification {
        val intent = Intent(applicationContext, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY
            putExtra("fromNotification", true) // Optional: add extra data
        }

        val pendingIntent = PendingIntent.getActivity(
            applicationContext,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Pomodoro Timer")
            .setContentText(content)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setSound(null)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setVibrate(longArrayOf(0))
            .setOngoing(true)
            .setContentIntent(pendingIntent)
            .setAutoCancel(false)
            .build()
    }

    private fun updateNotification(content: String) {
        val notification = createNotification(content)
        val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(NOTIFICATION_ID, notification)
    }

    @SuppressLint("DefaultLocale")
    private fun formatTime(seconds: Int): String {
        val minutes = seconds / 60
        val secs = seconds % 60
        return String.format("%02d:%02d", minutes, secs)
    }

    override fun onDestroy() {
        super.onDestroy()
        countDownTimer?.cancel()
        countDownTimer = null
        val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        manager.cancel(NOTIFICATION_ID)
    }

    override fun onBind(intent: Intent?): IBinder? = null

    }