package com.talkacharya.customer

import android.app.PictureInPictureParams
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.os.Build
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Picture-in-picture for video consultations.
 *
 * Entering PiP is an Activity call and the moment that matters — the user
 * pressing home or swiping up mid-call — only exists here, in
 * `onUserLeaveHint`. Dart says whether a video call is live; this decides
 * whether the window follows the user out of the app.
 */
class MainActivity : FlutterActivity() {

    private var channel: MethodChannel? = null

    /** Set from Dart while a video call is up. */
    private var videoCallActive = false

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
    }
}
