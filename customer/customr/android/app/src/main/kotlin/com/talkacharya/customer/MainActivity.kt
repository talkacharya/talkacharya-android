package com.talkacharya.customer

import android.app.PictureInPictureParams
import android.content.Context
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.os.Build
import android.os.PowerManager
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Native call bits Dart can't do for itself: picture-in-picture for video
 * consultations, the proximity screen-off every dialer has on a voice call, and
 * the bridge to [CallTelecom].
 *
 * Entering PiP is an Activity call and the moment that matters — the user
 * pressing home or swiping up mid-call — only exists here, in
 * `onUserLeaveHint`. Dart says whether a video call is live; this decides
 * whether the window follows the user out of the app.
 */
class MainActivity : FlutterActivity() {

    private var channel: MethodChannel? = null
    private var proximityChannel: MethodChannel? = null
    private var telecomChannel: MethodChannel? = null

    /** Set from Dart while a video call is up. */
    private var videoCallActive = false

    private var proximityLock: PowerManager.WakeLock? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "setActive" -> {
                        videoCallActive = call.argument<Boolean>("active") ?: false
                        result.success(null)
                    }
                    "enter" -> result.success(enterPip())
                    "isSupported" -> result.success(pipSupported())
                    else -> result.notImplemented()
                }
            }
        }
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
        telecomChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            TELECOM_CHANNEL,
        ).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "isSupported" -> result.success(CallTelecom.supported)
                    "start" -> result.success(
                        CallTelecom.start(
                            applicationContext,
                            call.argument<String>("peerName").orEmpty(),
                            call.argument<String>("callId").orEmpty(),
                        )
                    )
                    "end" -> {
                        CallTelecom.end()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        }
        // Telecom callbacks arrive on a binder thread; channels are main-thread only.
        CallTelecom.listener = { event, data ->
            runOnUiThread { telecomChannel?.invokeMethod(event, data) }
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

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        // Leaving the app during a video call shrinks it to a corner instead of
        // hiding the astrologer behind whatever the user opened next.
        if (videoCallActive) enterPip()
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration,
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        channel?.invokeMethod("pipChanged", isInPictureInPictureMode)
    }

    override fun onDestroy() {
        channel?.setMethodCallHandler(null)
        channel = null
        proximityChannel?.setMethodCallHandler(null)
        proximityChannel = null
        telecomChannel?.setMethodCallHandler(null)
        telecomChannel = null
        CallTelecom.listener = null
        releaseProximity()
        super.onDestroy()
    }

    private fun pipSupported(): Boolean =
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
            packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)

    private fun enterPip(): Boolean {
        // The version check is repeated here so the compiler can see it guards
        // the API 26 call below.
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return false
        if (!pipSupported() || isInPictureInPictureMode) return false
        return try {
            enterPictureInPictureMode(
                PictureInPictureParams.Builder()
                    // Portrait, like the call screen it comes from.
                    .setAspectRatio(Rational(9, 16))
                    .build()
            )
        } catch (e: IllegalStateException) {
            // Some devices refuse while finishing or locked; plain backgrounding
            // is the fallback and the call keeps running either way.
            false
        }
    }

    private companion object {
        const val CHANNEL = "talkacharya/pip"
        const val PROXIMITY_CHANNEL = "talkacharya/proximity"
        const val TELECOM_CHANNEL = "talkacharya/telecom"
        const val PROXIMITY_TAG = "talkacharya:call-proximity"

        /** Longer than any consultation; the real release comes from Dart. */
        const val PROXIMITY_TIMEOUT_MS = 4L * 60L * 60L * 1000L
    }
}
