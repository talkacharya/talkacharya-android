package com.talkacharya.customer

import android.content.Context
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Native call bits Dart can't do for itself: the proximity screen-off every
 * dialer has on a voice call. (The Telecom bridge lives in the talkacharya_call
 * plugin, so it also reaches the FCM background isolate.) There is no
 * picture-in-picture: only a voice call carries on in the background.
 */
class MainActivity : FlutterActivity() {

    private var proximityChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
            )
        }
    }

    private var proximityLock: PowerManager.WakeLock? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        proximityChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PROXIMITY_CHANNEL,
        ).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "setActive" -> {
                        setProximityActive(call.argument<Boolean>("active") ?: false)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    /**
     * Blank the screen while the phone is held to the ear, the way the system
     * dialer does — otherwise a voice call is a lit screen against a cheek,
     * muting itself and hanging up by accident.
     *
     * Released with RELEASE_FLAG_WAIT_FOR_NO_PROXIMITY so ending a call with
     * the phone still at the ear doesn't flash the screen on in between.
     */
    private fun setProximityActive(active: Boolean) {
        val power = getSystemService(Context.POWER_SERVICE) as? PowerManager ?: return
        if (!active) {
            releaseProximity()
            return
        }
        if (proximityLock?.isHeld == true) return
        if (!power.isWakeLockLevelSupported(PowerManager.PROXIMITY_SCREEN_OFF_WAKE_LOCK)) return
        val lock = proximityLock
            ?: power.newWakeLock(PowerManager.PROXIMITY_SCREEN_OFF_WAKE_LOCK, PROXIMITY_TAG)
                .also { proximityLock = it }
        try {
            // Timeout is a backstop only: Dart releases this when the call ends.
            lock.acquire(PROXIMITY_TIMEOUT_MS)
        } catch (e: RuntimeException) {
            // Unsupported or refused — the call carries on with the screen lit.
        }
    }

    private fun releaseProximity() {
        val lock = proximityLock ?: return
        proximityLock = null
        if (!lock.isHeld) return
        try {
            lock.release(PowerManager.RELEASE_FLAG_WAIT_FOR_NO_PROXIMITY)
        } catch (e: RuntimeException) {
            // already released
        }
    }

    override fun onDestroy() {
        proximityChannel?.setMethodCallHandler(null)
        proximityChannel = null
        releaseProximity()
        super.onDestroy()
    }

    private companion object {
        const val PROXIMITY_CHANNEL = "talkacharya/proximity"
        const val PROXIMITY_TAG = "talkacharya:call-proximity"

        /** Longer than any consultation; the real release comes from Dart. */
        const val PROXIMITY_TIMEOUT_MS = 4L * 60L * 60L * 1000L
    }
}
