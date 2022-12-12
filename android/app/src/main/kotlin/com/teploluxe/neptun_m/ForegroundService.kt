package com.teploluxe.neptun_m

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.IBinder
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import androidx.lifecycle.*
import com.example.neptun_m.R
import java.util.*

class ForegroundService : Service() {
    private val notificationId = 1
    var serviceRunning = false
    private lateinit var builder: NotificationCompat.Builder
    private lateinit var channel: NotificationChannel
    private lateinit var manager: NotificationManager

    override fun onCreate() {
        super.onCreate()
        startForeground()
        serviceRunning = true
        Timer().schedule(object : TimerTask() {
            override fun run() {
                if (serviceRunning) {
                    updateNotification("Система в работе")
                }
            }
        }, 5000)
    }


    override fun onDestroy() {
        super.onDestroy()
        serviceRunning = false
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun createNotificationChannel(channelId: String, channelName: String): String {
        channel = NotificationChannel(channelId,
            channelName, NotificationManager.IMPORTANCE_NONE)
        channel.lightColor = Color.BLUE
        channel.lockscreenVisibility = Notification.VISIBILITY_PRIVATE
        manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.createNotificationChannel(channel)
        return channelId
    }

    private fun startForeground() {
        val channelId =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                createNotificationChannel("main_service", "Фоновый сервис")
            } else {
                // If earlier version channel ID is not used
                // https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Builder.html#NotificationCompat.Builder(android.content.Context)
                ""
            }
        builder = NotificationCompat.Builder(this, channelId)
        builder
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("Диспетчеризация")
            .setContentText("Сервис Neptun Smart - в работе")
            .setCategory(Notification.CATEGORY_SERVICE)
        startForeground(1, builder.build())
    }

    private fun updateNotification(text: String) {
        builder
            .setContentText(text)
        manager.notify(notificationId, builder.build());
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }
}