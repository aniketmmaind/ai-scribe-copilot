package com.example.ai_scribe_copilot

import android.bluetooth.BluetoothHeadset
import android.bluetooth.BluetoothProfile
import android.content.*
import android.media.AudioManager
import io.flutter.plugin.common.MethodChannel

class AudioRoutingPlugin(
    private val context: Context,
    private val channel: MethodChannel
) {
    private val audioManager =
        context.getSystemService(Context.AUDIO_SERVICE) as AudioManager

    private val receiver = object : BroadcastReceiver() {
        override fun onReceive(ctx: Context?, intent: Intent?) {
            when (intent?.action) {

                Intent.ACTION_HEADSET_PLUG -> {
                    val state = intent.getIntExtra("state", -1)
                    if (state == 1) {
                        channel.invokeMethod("onRouteChanged", "wired")
                    } else {
                        channel.invokeMethod("onRouteChanged", "speaker")
                    }
                }

                BluetoothHeadset.ACTION_CONNECTION_STATE_CHANGED -> {
                    val state =
                        intent.getIntExtra(BluetoothProfile.EXTRA_STATE, -1)

                    if (state == BluetoothProfile.STATE_CONNECTED) {
                        channel.invokeMethod("onRouteChanged", "bluetooth")
                    }
                }
            }
        }
    }

    fun start() {
        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_HEADSET_PLUG)
            addAction(BluetoothHeadset.ACTION_CONNECTION_STATE_CHANGED)
        }
        context.registerReceiver(receiver, filter)
    }

    fun stop() {
        context.unregisterReceiver(receiver)
    }

    fun forceMicRoute(route: String) {
        when (route) {
            "wired" -> {
                audioManager.mode = AudioManager.MODE_IN_COMMUNICATION
                audioManager.isSpeakerphoneOn = false
                audioManager.stopBluetoothSco()
            }

            "bluetooth" -> {
                audioManager.mode = AudioManager.MODE_IN_COMMUNICATION
                audioManager.startBluetoothSco()
                audioManager.isBluetoothScoOn = true
            }

            else -> {
                audioManager.mode = AudioManager.MODE_NORMAL
                audioManager.isSpeakerphoneOn = true
                audioManager.stopBluetoothSco()
            }
        }
    }
}
