package com.example.memories_photos

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import android.net.Uri
import android.os.Bundle
import android.os.Environment
import android.provider.Settings
import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.core.net.toUri

class MainActivity : FlutterActivity() {
    private val CHANNEL_EXIF = "mb28.monoP.exif/exif_channel"
    private val CHANNEL_Helper = "mb28.monoP.helper/helper_channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_EXIF
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAttribute" -> {
                    val exifDart = ExifDart()
                    val theAtt =
                        exifDart.getAttribute(
                            call.argument<String>("path")!!,
                            call.argument<String>("tag")!!
                        )
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

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_Helper
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "isExternalStorageManager" -> {
                    result.success(Environment.isExternalStorageManager())
                }

                "openAllFilesAccess" -> {
                    val intent = Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION)
                    intent.setData(Uri.fromParts("package", packageName, null))
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(intent)
                    result.success(true)
                }
                "openWithMaps" -> {
                    val lat = call.argument<String>("lat")!!
                    val long = call.argument<String>("long")!!
                    val mapUri = "https://maps.google.com/maps/search/${lat.subSequence(0, 2)},${long.subSequence(0, 2)}".toUri()
                    val intent = Intent(Intent.ACTION_VIEW, mapUri)
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(intent)
                    result.success(true)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }

    }
}
