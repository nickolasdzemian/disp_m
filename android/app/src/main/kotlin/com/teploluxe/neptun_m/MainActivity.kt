package com.teploluxe.neptun_m

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import it.alessangiorgi.ipneigh30.ArpNDK


class MainActivity: FlutterActivity() {
    // override fun onCreate(savedInstanceState: Bundle?) {
    //     super.onCreate(savedInstanceState)
    //     requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
    // }

    private val channel = "com.example.neptun_m/common"
    lateinit var mainHandler: Handler

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        mainHandler = Handler(Looper.getMainLooper())
    }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
                call, result ->

            fun zaloop() {
                MethodChannel(
                    flutterEngine.dartExecutor.binaryMessenger,
                    channel
                ).invokeMethod("zaloop", null)
            }

            when (call.method) {
                "getArpTable" -> {
                    result.success(getArpTable())
                }
                "startService" -> {
                    startService(Intent(this, ForegroundService::class.java))
                    result.success("Started!")
                }
                "stopService" -> {
                    stopService(Intent(this, ForegroundService::class.java))
                    result.success("Stopped!")
                }
                "startBackground" -> {
                    val hashMap = call.arguments as HashMap<*,*> //Get the arguments as a HashMap
                    val dura = hashMap["dura"] //Get the argument based on the key passed from Flutter
                    mainHandler.post(object : Runnable {
                        override fun run() {
                            zaloop()
                            mainHandler.postDelayed(this, dura.toString().toLong() * 1000)
                        }
                    })
                    result.success("Started!")
                }
                "stopBackground" -> {
                    mainHandler.removeCallbacksAndMessages(null);
                    result.success("Stopped!")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getArpTable(): String {
        val arpTable = ArpNDK.getARP();
        return arpTable
    }

}

