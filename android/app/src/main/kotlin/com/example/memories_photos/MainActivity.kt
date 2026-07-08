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

class MainActivity : FlutterActivity() {
    private val CHANNEL_EXIF = "mb28.monoP.exif/exif_channel"
    private val CHANNEL_CAMERA = "mb28.monoP.camera/camera_channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        window.navigationBarColor = 0x00000000

        if (!Environment.isExternalStorageManager()) {
            val intent = Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION)
            intent.setData(Uri.fromParts("package", packageName, null))
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
            Toast.makeText(applicationContext, "All files access is rejected", Toast.LENGTH_SHORT).show()
        }
        //if (checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
        //    requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 2)
        // }
        super.onCreate(savedInstanceState)
        //LiveNotifs().show(this)
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
    }

//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_CAMERA).setMethodCallHandler {
//            call, result ->
//            when (call.method) {
//                "takePictureAndroid" -> {
//                    val i = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
//                        i.putExtra(
//                            MediaStore.EXTRA_OUTPUT,
//                            MediaStore.Images.Media.EXTERNAL_CONTENT_URI
//                        )
//                    startActivityForResult(i, 28001)
//                    result.success("")
//                }
//                else -> {
//                    result.notImplemented()
//                }
//            }
//        }
//    }
//
//    override fun onActivityResult(
//        requestCode: Int,
//        resultCode: Int,
//        data: Intent?,
//        caller: ComponentCaller
//    ) {
//
//        super.onActivityResult(requestCode, resultCode, data, caller)
//    }

}
