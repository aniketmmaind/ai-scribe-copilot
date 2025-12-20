package com.example.ai_scribe_copilot

import android.app.NotificationManager
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

class DndCheckerPlugin : FlutterPlugin {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "dnd_check")

        channel.setMethodCallHandler { call, result ->
            if (call.method == "isDndEnabled") {
                val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                val enabled = nm.currentInterruptionFilter != NotificationManager.INTERRUPTION_FILTER_ALL
                result.success(enabled)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
