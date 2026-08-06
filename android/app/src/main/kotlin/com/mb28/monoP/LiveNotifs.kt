package com.example.memories_photos

import android.app.Notification
import android.app.Notification.FLAG_ONGOING_EVENT
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.NotificationManager.*
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.app.NotificationCompat

class LiveNotifs {
    private val ChannelID = "MONOP_LIVE"
    private val NOTIF_ID = 28

    fun show(context: Context) {
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channel = NotificationChannel(ChannelID, "MonoP Live Notifs", IMPORTANCE_HIGH)
        manager.createNotificationChannel(channel)

       if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.BAKLAVA) {
           if (!manager.canPostPromotedNotifications()) {
               val intent = Intent(Settings.ACTION_APP_NOTIFICATION_PROMOTION_SETTINGS)
               intent.putExtra(Settings.EXTRA_APP_PACKAGE, context.packageName)
               context.startActivity(intent)
           }
       }

        // It seems notification compact is still haven't updated for sdk 36, so I used normal notification builder
        val nt = Notification.Builder(context, ChannelID)
            .setContentTitle("Title")
            .setContentText("ConText")
            .setSubText("SubText")
            .setProgress(10, 5, false)
            .setSmallIcon(R.drawable.icon_notif)
            .setColor(0xffaaaaaa.toInt())
            .setOngoing(true)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.BAKLAVA)
            nt.setShortCriticalText("YO")

        manager.notify(NOTIF_ID, nt.build())
    }
}