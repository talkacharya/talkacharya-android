package com.talkacharya.call;

import android.annotation.TargetApi;
import android.os.Build;
import android.telecom.CallAudioState;
import android.telecom.Connection;
import android.telecom.DisconnectCause;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * The Telecom end of one consultation call. Everything the system tells it is
 * forwarded to Dart, which owns the actual call.
 */
@TargetApi(Build.VERSION_CODES.O)
public class CallConnection extends Connection {

    final String callId;

    CallConnection(String callId) {
        this.callId = callId == null ? "" : callId;
        setConnectionProperties(PROPERTY_SELF_MANAGED);
        setConnectionCapabilities(CAPABILITY_HOLD | CAPABILITY_SUPPORT_HOLD);
        setAudioModeIsVoip(true);
    }

    /** Answered by the system — a headset button, a watch, a car. */
    @Override
    public void onAnswer() {
        if (CallTelecom.ringing == this) {
            CallTelecom.answeredBySystem(this);
        } else {
            setActive();
        }
    }

    @Override
    public void onAnswer(int videoState) {
        onAnswer();
    }

    /** Declined by the system while ringing. */
    @Override
    public void onReject() {
        if (CallTelecom.ringing == this) CallTelecom.ringing = null;
        CallTelecom.emit("reject", CallTelecom.callIdMap(callId));
        finish(DisconnectCause.REJECTED);
    }

    @Override
    public void onDisconnect() {
        if (CallTelecom.ringing == this) {
            // Hung up before it was ever answered: a decline, not a dropped call.
            onReject();
            return;
        }
        // The headset's hang-up button, or Telecom making room for a cellular
        // call. Either way the consultation should end, not linger unheard.
        Map<String, Object> data = CallTelecom.callIdMap(callId);
        data.put("reason", "local");
        CallTelecom.emit("disconnect", data);
        finish(DisconnectCause.LOCAL);
    }

    @Override
    public void onAbort() {
        Map<String, Object> data = CallTelecom.callIdMap(callId);
        data.put("reason", "aborted");
        CallTelecom.emit("disconnect", data);
        finish(DisconnectCause.CANCELED);
    }

    @Override
    public void onHold() {
        setOnHold();
        CallTelecom.emit("hold", CallTelecom.callIdMap(callId));
    }

    @Override
    public void onUnhold() {
        setActive();
        CallTelecom.emit("unhold", CallTelecom.callIdMap(callId));
    }

    /**
     * Where the audio is, and where it could go. The call screen offers a choice
     * only when there is one — a headset connected, or one plugged in.
     */
    @Override
    public void onCallAudioStateChanged(CallAudioState state) {
        int route = state.getRoute();
        int mask = state.getSupportedRouteMask();
        List<String> routes = new ArrayList<>();
        if ((mask & CallAudioState.ROUTE_EARPIECE) != 0) routes.add("earpiece");
        if ((mask & CallAudioState.ROUTE_WIRED_HEADSET) != 0) routes.add("wired");
        if ((mask & CallAudioState.ROUTE_SPEAKER) != 0) routes.add("speaker");
        if ((mask & CallAudioState.ROUTE_BLUETOOTH) != 0) routes.add("bluetooth");

        Map<String, Object> data = new HashMap<>();
        data.put("callId", callId);
        data.put("muted", state.isMuted());
        data.put("speaker", route == CallAudioState.ROUTE_SPEAKER);
        data.put("bluetooth", route == CallAudioState.ROUTE_BLUETOOTH);
        data.put("route", nameOf(route));
        data.put("routes", routes);
        CallTelecom.emit("audio", data);
    }

    private static String nameOf(int route) {
        switch (route) {
            case CallAudioState.ROUTE_SPEAKER: return "speaker";
            case CallAudioState.ROUTE_BLUETOOTH: return "bluetooth";
            case CallAudioState.ROUTE_WIRED_HEADSET: return "wired";
            default: return "earpiece";
        }
    }

    void finish(int cause) {
        setDisconnected(new DisconnectCause(cause));
        destroy();
        if (CallTelecom.connection == this) CallTelecom.connection = null;
        if (CallTelecom.ringing == this) CallTelecom.ringing = null;
    }
}
