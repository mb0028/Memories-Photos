package com.example.memories_photos

import android.Manifest
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.Uri
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.Settings
import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "mb28.monoP.exif/exif_channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        if (!Environment.isExternalStorageManager()) {
            val intent =
                Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION)
            intent.setData(Uri.fromParts("package", packageName, null))
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
            Toast.makeText(applicationContext, "All files access is rejected", Toast.LENGTH_SHORT).show()
        }
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "getAttribute" -> {
                    val exifDart = ExifDart()
                    val theAtt =
                        exifDart.getAttribute(call.argument<String>("path")!!, call.argument<String>("tag")!!)
                    result.success(theAtt)
                }
                "setAttribute" -> {
                    val exifDart = ExifDart()
                    val sett = exifDart.setAttribute(
                        call.argument<String>("path")!!,
                        call.argument<String>("tag")!!,
                        call.argument<String>("value")!!
                    )
                    if (!sett)
                        result.error("0", "Failed to set exif tag.", sett)
                    result.success(sett)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

}
