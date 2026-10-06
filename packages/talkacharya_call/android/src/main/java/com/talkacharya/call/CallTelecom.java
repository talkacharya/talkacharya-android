package com.talkacharya.call;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.annotation.TargetApi;
import android.telecom.CallAudioState;
import android.telecom.DisconnectCause;
import android.telecom.PhoneAccount;
import android.telecom.PhoneAccountHandle;
import android.telecom.TelecomManager;


import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

/**
 * Registers consultation calls with Android's telecom stack as *self-managed*
 * calls, so the OS treats them as real calls rather than an app making noise.
 *
 * <ul>
 *   <li><b>Incoming.</b> A ringing voice/video consultation is reported with
 *   {@code addNewIncomingCall}: Android knows the phone is ringing, a headset or
 *   watch can answer it, and a cellular call already in progress gets the
 *   system's "answer and end the other call" choice instead of two apps talking
 *   over each other.</li>
 *   <li><b>Cellular interop.</b> A GSM call arriving mid-consultation holds ours
 *   through Telecom.</li>
 *   <li><b>Audio routing.</b> Telecom owns the route — earpiece, speaker, wired
 *   or Bluetooth headset — and reports which ones exist, which is what lets the
 *   call screen offer a choice.</li>
 *   <li><b>Calling-app status.</b> From Android 14 {@code USE_FULL_SCREEN_INTENT},
 *   which the whole ringing flow needs, is only granted to calling apps.</li>
 * </ul>
 *
 * <p>Self-managed calls keep their own UI (the app's full-screen notification and
 * call screen); Android draws no call screen and writes no call-log entry.
 *
 * <p>Needs API 26. Below that, and whenever Telecom refuses, every entry point is
 * a no-op: nothing here may ever be the reason a paid consultation fails.
 */
// API 26 throughout; every public entry point checks SDK_INT itself before
// touching Telecom, which is what makes the class-wide target safe.
@TargetApi(Build.VERSION_CODES.O)
public final class CallTelecom {

    static final String EXTRA_PEER_NAME = "com.talkacharya.PEER_NAME";
    static final String EXTRA_CALL_ID = "com.talkacharya.CALL_ID";
    static final String EXTRA_EXPIRES_MS = "com.talkacharya.EXPIRES_MS";
    static final String EXTRA_VIDEO = "com.talkacharya.VIDEO";

    private static final String ACCOUNT_ID = "talkacharya-calls";
    private static final String ACCOUNT_LABEL = "TalkAcharya";

    /** One per Flutter engine the plugin is attached to (app UI, FCM isolate). */
    interface Listener {
        void onEvent(String event, Map<String, Object> data);
    }

    private static final Set<Listener> listeners = new CopyOnWriteArraySet<>();
    private static final Handler main = new Handler(Looper.getMainLooper());

    /** The call Telecom is managing as live. */
    static CallConnection connection;

    /** A reported incoming call nobody has answered yet. */
    static CallConnection ringing;

    /**
     * Answered through Telecom (headset, watch, car) while no app screen was
     * listening. Dart collects it on start-up so the answer is not lost.
     */
    static String pendingAnswer;

    static Context appContext;

    private static boolean registered = false;

    private CallTelecom() {}

    static boolean supported() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.O;
    }

    static void addListener(Listener l) { listeners.add(l); }

    static void removeListener(Listener l) { listeners.remove(l); }

    static boolean hasListeners() { return !listeners.isEmpty(); }

    /** Telecom calls back on binder threads; channels are main-thread only. */
    static void emit(String event, Map<String, Object> data) {
        main.post(() -> {
            for (Listener l : listeners) {
                try {
                    l.onEvent(event, data);
                } catch (RuntimeException ignored) {
                    // one engine going away must not starve the others
                }
            }
        });
    }

    static Map<String, Object> callIdMap(String callId) {
        Map<String, Object> m = new HashMap<>();
        m.put("callId", callId == null ? "" : callId);
        return m;
    }

    private static TelecomManager telecom(Context context) {
        return (TelecomManager) context.getSystemService(Context.TELECOM_SERVICE);
    }

    @TargetApi(Build.VERSION_CODES.O)
    static PhoneAccountHandle handle(Context context) {
        return new PhoneAccountHandle(
            new ComponentName(context.getApplicationContext(), CallConnectionService.class),
            ACCOUNT_ID
        );
    }

    /** Self-managed accounts need no consent and no dialer role. */
    @TargetApi(Build.VERSION_CODES.O)
    private static boolean register(Context context) {
        if (registered) return true;
        TelecomManager manager = telecom(context);
        if (manager == null) return false;
        try {
            manager.registerPhoneAccount(
                PhoneAccount.builder(handle(context), ACCOUNT_LABEL)
                    .setCapabilities(PhoneAccount.CAPABILITY_SELF_MANAGED)
                    .addSupportedUriScheme(PhoneAccount.SCHEME_SIP)
                    .build()
            );
            registered = true;
            return true;
        } catch (SecurityException | IllegalArgumentException e) {
            return false;
        }
    }

    private static Uri address(String callId) {
        return Uri.fromParts(PhoneAccount.SCHEME_SIP, callId + "@talkacharya", null);
    }

    // --- incoming ------------------------------------------------------------

    /**
     * Tell Android a consultation call is ringing on this phone. The app still
     * shows its own full-screen notification; this is what makes the OS treat it
     * as a call. Telecom ends it by itself after {@code expiresMs} if nobody
     * answers, so a request that times out never leaves a phantom call behind.
     */
    static boolean reportIncoming(
        Context context, String callId, String peerName, boolean video, long expiresMs
    ) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O || callId.isEmpty()) return false;
        TelecomManager manager = telecom(context);
        if (manager == null || !register(context)) return false;
        PhoneAccountHandle account = handle(context);
        try {
            if (!manager.isIncomingCallPermitted(account)) return false;
            // Already ringing for this one (a push and the socket both said so).
            if (ringing != null && callId.equals(ringing.callId)) return true;
            Bundle inner = new Bundle();
            inner.putString(EXTRA_PEER_NAME, peerName);
            inner.putString(EXTRA_CALL_ID, callId);
            inner.putLong(EXTRA_EXPIRES_MS, expiresMs);
            inner.putBoolean(EXTRA_VIDEO, video);
            Bundle extras = new Bundle();
            extras.putParcelable(TelecomManager.EXTRA_INCOMING_CALL_ADDRESS, address(callId));
            extras.putBundle(TelecomManager.EXTRA_INCOMING_CALL_EXTRAS, inner);
            manager.addNewIncomingCall(account, extras);
            return true;
        } catch (SecurityException | IllegalArgumentException | IllegalStateException e) {
            return false;
        }
    }

    /** Called by the service once Telecom has built the ringing connection. */
    static void onRinging(CallConnection c, long expiresMs) {
        CallConnection previous = ringing;
        if (previous != null && previous != c) previous.finish(DisconnectCause.MISSED);
        ringing = c;
        long timeout = expiresMs > 0 ? expiresMs : 90_000L;
        main.postDelayed(() -> {
            if (ringing == c) {
                c.finish(DisconnectCause.MISSED);
                emit("missed", callIdMap(c.callId));
            }
        }, timeout);
    }

    /** The app accepted it (its own Answer button). The ring becomes the call. */
    static boolean answerIncoming(String callId) {
        CallConnection c = ringing;
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O || c == null || !callId.equals(c.callId)) return false;
        promote(c);
        return true;
    }

    /** Answered by Telecom itself — a headset button, a watch, a car. */
    static void answeredBySystem(CallConnection c) {
        promote(c);
        if (hasListeners()) {
            emit("answer", callIdMap(c.callId));
        } else {
            // No app screen to hear it: remember it and bring the app forward.
            pendingAnswer = c.callId;
            bringAppForward();
        }
    }

    private static void promote(CallConnection c) {
        if (ringing == c) ringing = null;
        CallConnection previous = connection;
        if (previous != null && previous != c) previous.finish(DisconnectCause.LOCAL);
        connection = c;
        c.setActive();
    }

    /** Declined in the app, or the request was withdrawn. */
    static void declineIncoming(String callId) {
        CallConnection c = ringing;
        if (c == null || !callId.equals(c.callId)) return;
        ringing = null;
        c.finish(DisconnectCause.REJECTED);
    }

    private static void bringAppForward() {
        Context context = appContext;
        if (context == null) return;
        try {
            Intent launch = context.getPackageManager()
                .getLaunchIntentForPackage(context.getPackageName());
            if (launch == null) return;
            launch.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP);
            context.startActivity(launch);
        } catch (RuntimeException ignored) {
            // Background-start limits: the ringing notification is still there.
        }
    }

    static String takePendingAnswer() {
        String id = pendingAnswer;
        pendingAnswer = null;
        return id;
    }

    // --- live call -------------------------------------------------------------

    /**
     * Hand a call that is under way to Telecom. If it was reported as incoming,
     * that connection is adopted rather than a second one placed.
     */
    static boolean start(Context context, String peerName, String callId) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return false;
        CallConnection active = connection;
        if (active != null && callId.equals(active.callId)) return true;
        CallConnection ring = ringing;
        if (ring != null && callId.equals(ring.callId)) {
            promote(ring);
            return true;
        }
        return place(context, peerName, callId);
    }

    @TargetApi(Build.VERSION_CODES.O)
    private static boolean place(Context context, String peerName, String callId) {
        TelecomManager manager = telecom(context);
        if (manager == null || !register(context)) return false;
        PhoneAccountHandle account = handle(context);
        try {
            if (!manager.isOutgoingCallPermitted(account)) return false;
            Bundle inner = new Bundle();
            inner.putString(EXTRA_PEER_NAME, peerName);
            inner.putString(EXTRA_CALL_ID, callId);
            Bundle extras = new Bundle();
            extras.putParcelable(TelecomManager.EXTRA_PHONE_ACCOUNT_HANDLE, account);
            extras.putBundle(TelecomManager.EXTRA_OUTGOING_CALL_EXTRAS, inner);
            manager.placeCall(address(callId), extras);
            return true;
        } catch (SecurityException | IllegalStateException e) {
            return false;
        }
    }

    /** Legacy speaker toggle, kept for older Dart callers. */
    static boolean setSpeaker(boolean on) {
        return setAudioRoute(on ? "speaker" : "earpiece");
    }

    /**
     * Move the audio. "earpiece" means whichever wired route exists — Android
     * treats a plugged-in headset as replacing the earpiece.
     */
    static boolean setAudioRoute(String route) {
        CallConnection active = connection;
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O || active == null) return false;
        int target;
        switch (route) {
            case "speaker": target = CallAudioState.ROUTE_SPEAKER; break;
            case "bluetooth": target = CallAudioState.ROUTE_BLUETOOTH; break;
            case "wired": target = CallAudioState.ROUTE_WIRED_HEADSET; break;
            default: target = CallAudioState.ROUTE_WIRED_OR_EARPIECE; break;
        }
        try {
            active.setAudioRoute(target);
            return true;
        } catch (RuntimeException e) {
            return false;
        }
    }

    /** The call ended in our own stack — release the Telecom side too. */
    static void end() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return;
        CallConnection active = connection;
        connection = null;
        if (active != null) active.finish(DisconnectCause.LOCAL);
        CallConnection ring = ringing;
        ringing = null;
        if (ring != null) ring.finish(DisconnectCause.LOCAL);
    }
}
