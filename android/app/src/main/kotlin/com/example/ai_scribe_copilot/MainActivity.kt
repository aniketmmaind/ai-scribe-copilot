package com.example.ai_scribe_copilot

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

class MainActivity : FlutterActivity() {

    private lateinit var audioRouting: AudioRoutingPlugin

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        flutterEngine.plugins.add(DndCheckerPlugin())

        val channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "audio_route"
        )

        audioRouting = AudioRoutingPlugin(this, channel)

        channel.setMethodCallHandler { call: MethodCall, result: Result ->
            when (call.method) {
                "start" -> {
                    audioRouting.start()
                    result.success(null)
                }

                "forceRoute" -> {
                    val route = call.arguments as String
                    audioRouting.forceMicRoute(route)
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }
}
